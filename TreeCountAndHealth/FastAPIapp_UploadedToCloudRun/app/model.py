from ultralytics import YOLO
import cv2
import os
from collections import Counter
from functools import lru_cache

@lru_cache()
def get_model():
    return YOLO("app/models/best.pt")

def process_image(img_path):
    model = get_model()
    # Run inference
    results = model.predict(img_path, save=False)
    result = results[0]

    # Load image
    img = cv2.imread(img_path)

    # Get class names
    class_names = model.names

    class_ids = []
    for box in result.boxes:
        x1, y1, x2, y2 = box.xyxy[0].tolist()
        cls_id = int(box.cls[0])
        class_ids.append(cls_id)
        cx = int((x1 + x2) / 2)
        cy = int((y1 + y2) / 2)
        color = (0, 255, 0) if class_names[cls_id] == 'Healthy' else (0, 0, 255)
        cv2.circle(img, (cx, cy), radius=15, color=color, thickness=-1)

    # Save result image
    output_path = os.path.join("app/outputs", "dot_view_result.png")
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    cv2.imwrite(output_path, img)

    # Count detections
    label_counts = Counter([class_names[cid] for cid in class_ids])
    total = sum(label_counts.values())

    return {
        "detection_summary": label_counts,
        "total_trees": total,
        "output_image": output_path
    }
