from ultralytics import YOLO

model=YOLO(r'c:\Users\minet\OneDrive\Desktop\3YP\Tree_counting\models\best.pt')
results = model.predict(r'c:\Users\minet\OneDrive\Desktop\3YP\Tree_counting\img.png', save=True) 
print(results[0])

num_palm_trees = len(results[0].boxes)  # The length of the boxes array represents the number of detections

print(f"Number of detected palm trees: {num_palm_trees}")
