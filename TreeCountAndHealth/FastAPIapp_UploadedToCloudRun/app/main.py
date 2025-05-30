from fastapi import FastAPI, UploadFile, File, HTTPException
from pydantic import BaseModel
from fastapi.responses import JSONResponse
from app.model import process_image
import shutil, uuid, os
from app.gcs_utils import upload_to_gcs
from app.firestore_utils import save_to_firestore

app = FastAPI()

# class ImageURLRequest(BaseModel):
#     image_url: str

@app.post("/predict/")
async def predict(file: UploadFile = File(...)):
    
    try:

        # Save uploaded file temporarily
        temp_filename = f"app/uploads/temp_{uuid.uuid4().hex}.jpg"
        os.makedirs(os.path.dirname(temp_filename), exist_ok=True)

        with open(temp_filename, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        # Upload input image to GCS
        input_url = upload_to_gcs(temp_filename, folder="inputs/")

        # Run detection
        result = process_image(temp_filename)

        # Upload output image to GCS
        output_url = upload_to_gcs(result["output_image"], folder="outputs/")

        # Prepare metadata
        metadata = {
            "input_image_url": input_url,
            "output_image_url": output_url,
            "tree_count": result["total_trees"],
            "detection_summary": result["detection_summary"]
        }

        # Store metadata to Firestore
        save_to_firestore(metadata)

        return metadata
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    # Save uploaded file temporarily
    # upload_dir = "app/uploads"
    # os.makedirs(upload_dir, exist_ok=True)
    # image_path = os.path.join(upload_dir, file.filename)
    
    # with open(image_path, "wb") as buffer:
    #     shutil.copyfileobj(file.file, buffer)

    # # Run inference
    # try:
    #     result = process_image(image_path)
    #     return JSONResponse(content=result)
    # except Exception as e:
    #     return JSONResponse(status_code=500, content={"error": str(e)})
