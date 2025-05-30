from google.cloud import storage
import os
import uuid

# Authenticate using service account
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "app/gcp-key.json"

BUCKET_NAME = "tree_detector_storage"

def upload_to_gcs(local_path, folder="uploads/"):

    # Generate a unique filename
    filename = os.path.basename(local_path)
    unique_filename = f"{uuid.uuid4().hex}_{filename}"
    destination_blob_name = f"{folder}{unique_filename}"

    client = storage.Client()
    bucket = client.bucket(BUCKET_NAME)
    blob = bucket.blob(destination_blob_name)

    # Upload the file
    blob.upload_from_filename(local_path)

    # Construct public URL manually (assumes bucket is publicly readable)
    public_url = f"https://storage.googleapis.com/{BUCKET_NAME}/{destination_blob_name}"
    return public_url
    # client = storage.Client()
    # bucket = client.bucket(BUCKET_NAME)
    # filename = f"{uuid.uuid4().hex}_{os.path.basename(local_path)}"
    # blob = bucket.blob(f"{folder}{filename}")
    # blob.upload_from_filename(local_path)
    # blob.make_public()
    # return blob.public_url
