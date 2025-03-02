from ultralytics import YOLO

model=YOLO(r'c:\Users\minet\OneDrive\Desktop\3YP\Tree_health\models\best.pt')
results = model.predict(r'C:\Users\minet\OneDrive\Desktop\3YP\Tree_health\Oil Palm Health Detection.v2i.yolov5pytorch\train\images\44000_4000_565_2003_jpg.rf.43baec04f3a9c541df8b61b16d32a933.jpg', save=True) 
print(results[0])

num_palm_trees = len(results[0].boxes)  # The length of the boxes array represents the number of detections

print(f"Number of detected palm trees: {num_palm_trees}")
