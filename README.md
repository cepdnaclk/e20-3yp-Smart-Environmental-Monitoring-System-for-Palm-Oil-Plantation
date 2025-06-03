___
# Smart Environmental Monitoring System for Palm Oil Plantation in Watawala
___

Welcome to our innovative Smart Agricultural Monitoring System, a seamless blend of technology and sustainability. Our project focuses on remotely monitor critical environmental factors essential for crop health, such as:
-Temperature
-Humidity
-Light Intensity
-Soil Moisture
-Location

The system collects real-time data from sensors placed in the field, transmits it to Firebase Firestore for storage and analysis. With this setup, managers can access live data through a user-friendly Mobile interface, enabling them to make data-driven decisions. Our solution aims to enhance agricultural productivity, reduce resource waste, and promote sustainable farming practices.

##System

Our system is an IoT-based smart agriculture solution designed to monitor and analyze environmental conditions like temperature, humidity, light intensity, and soil moisture. It collects real-time data using sensors connected to an ESP32, transmitting information through LoRa and storing it in Firebase for analysis and visualization.

![HighLevelSystem](https://github.com/user-attachments/assets/675dd054-87cc-4fc2-b4c7-0c1986ef7081)

##Highlevel System

The high-level system architecture includes interconnected components: sensors gathering data, ESP32 acting as the main controller, LoRa nodes for long-range communication, and Firebase as the backend for real-time data storage. The user interacts with the front-end web interface to view insights and predictions, while ML models process data trends for informed decision-making.

##Implementation

Implementation involves integrating hardware and software components. Sensors are connected to the ESP32 for data collection, with LoRa nodes facilitating long-range data transmission. The ESP32 uploads data to Firebase via Wi-Fi, where it’s processed and displayed on a dynamic web interface. The ML model, trained using sensor data, predicts environmental trends, helping optimize plantation management.

![3YPFinal](https://github.com/user-attachments/assets/70dc4d7f-8dee-4a88-bb2d-c71283962d82)

