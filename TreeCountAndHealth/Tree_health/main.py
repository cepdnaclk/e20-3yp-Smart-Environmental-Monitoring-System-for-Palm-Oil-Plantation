from ultralytics import YOLO
import cv2
import os
from collections import Counter

# Load model
model = YOLO(r'c:\Users\minet\OneDrive\Desktop\3YP\Tree_health\models\best.pt')

# Input image path
img_path = r'C:\Users\minet\OneDrive\Desktop\3YP\Tree_health\Oil Palm Health Detection.v2i.yolov5pytorch\train\images\44000_4000_565_2003_jpg.rf.43baec04f3a9c541df8b61b16d32a933.jpg'

# Run inference
results = model.predict(img_path, save=False)
result = results[0]

# Load original image
img = cv2.imread(img_path)

# Get class mapping
class_names = model.names  # e.g., {0: 'Healthy', 1: 'Unhealthy'}

# Initialize count
class_ids = []
for box in result.boxes:
    x1, y1, x2, y2 = box.xyxy[0].tolist()
    cls_id = int(box.cls[0])
    class_ids.append(cls_id)
    
    # Calculate center of the bounding box
    cx = int((x1 + x2) / 2)
    cy = int((y1 + y2) / 2)

    # Draw dot: green for healthy, red for unhealthy
    color = (0, 255, 0) if class_names[cls_id] == 'Healthy' else (0, 0, 255)
    cv2.circle(img, (cx, cy), radius=15, color=color, thickness=-1)

# Save output image
output_path = r'runs\detect\dot_view.png'
os.makedirs(os.path.dirname(output_path), exist_ok=True)
cv2.imwrite(output_path, img)

# Count and print results
label_counts = Counter([class_names[cid] for cid in class_ids])
total = sum(label_counts.values())

print("Detection Summary:")
for label in class_names.values():
    print(f"{label}: {label_counts.get(label, 0)}")
print(f"Total Palm Trees Detected: {total}")
print(f"Dot-based visualization saved to: {output_path}")
