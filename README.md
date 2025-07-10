___
# Smart Environmental Monitoring System for Palm Oil Plantation in Watawala
___

Welcome to our innovative Smart Agricultural Monitoring System, a seamless blend of technology and sustainability. Our project focuses on remotely monitor critical environmental factors essential for crop health, such as:
- Temperature
- Humidity
- Light Intensity
- Soil Moisture
- Location

The system collects real-time data from sensors placed in the field, transmits it to Firebase Firestore for storage and analysis. With this setup, managers can access live data through a user-friendly Mobile interface, enabling them to make data-driven decisions. Our solution aims to enhance agricultural productivity, reduce resource waste, and promote sustainable farming practices.

## System

Our system is an IoT-based smart agriculture solution designed to monitor and analyze environmental conditions like temperature, humidity, light intensity, and soil moisture. It collects real-time data using sensors connected to an ESP32, transmitting information through LoRa and storing it in Firebase for analysis and visualization.

![HighLevelSystem](https://github.com/user-attachments/assets/675dd054-87cc-4fc2-b4c7-0c1986ef7081)

## Highlevel System

The high-level system architecture includes interconnected components: sensors gathering data, ESP32 acting as the main controller, LoRa nodes for long-range communication, and Firebase as the backend for real-time data storage. The user interacts with the front-end web interface to view insights and predictions, while ML models process data trends for informed decision-making.

## Implementation

Implementation involves integrating hardware and software components. Sensors are connected to the ESP32 for data collection, with LoRa nodes facilitating long-range data transmission. The ESP32 uploads data to Firebase via Wi-Fi, where it’s processed and displayed on a dynamic web interface. The ML model, trained using sensor data, predicts environmental trends, helping optimize plantation management.

![3YPFinal](https://github.com/user-attachments/assets/70dc4d7f-8dee-4a88-bb2d-c71283962d82)

## Software Design

The user interface is a web-based dashboard that visually displays real-time sensor data, including temperature, humidity, light intensity, and soil moisture levels. It offers an intuitive layout with graphs, maps, and alerts for easy monitoring.

![userInterface](https://github.com/user-attachments/assets/06dc1a6f-5c15-402d-9000-975473183c84)

## Hardware Design

Sensors and Modules,
- ESP32 Microcontroller
- DHT22 Sensor
- Hall Sensor
- Neo-6M Sensor
- Capacitive Soil Moisture Sensor
- NPK Sensor
- BH1750 Light Intensity Sensor
- DC to DC step down module
- Rechargeable Battery

### Main Circuit Diagram

![circuitDiagram](https://github.com/user-attachments/assets/3c5c8f9d-9839-40be-9d55-ae4fa8a59610)

Our Main Circuit Diagram illustrates the core components of our Smart Agricultural Monitoring System built around the ESP32 microcontroller. The system integrates multiple sensors, including the DHT22 for temperature and humidity, BH1750 for light intensity, and a soil moisture sensor to assess soil health. The Neo-6M GPS module provides real-time location data, while the hall sensor detects magnetic field changes, useful for monitoring mechanical operations. An LCD display is connected to visually present sensor readings directly. All components are powered by a battery source, with proper wiring ensuring stable communication through I2C (SDA, SCL pins) for the BH1750 and LCD, and GPIO pins for the remaining sensors. This setup enables seamless data collection and transmission via the ESP32, forming the foundation for real-time, remote agricultural monitoring.

### Prototype

![Prototype](https://github.com/user-attachments/assets/2d336a3c-55f7-4c43-9b38-2624793007a8)

### 3D Design

![3d design](https://github.com/user-attachments/assets/0947603e-4e4b-4007-a5a0-f4996fa2029f)

## Testing
### Software Frontend Testing

Focuses on ensuring the user interface works seamlessly. This includes verifying correct data visualization, responsive design across devices, and smooth user interactions, ensuring real-time sensor data displays without glitches.

![signup_test](https://github.com/user-attachments/assets/1ec1316d-cf42-44a0-bb28-6b405d3f53fa)

### Hardware Testing

![hardware-testing1](https://github.com/user-attachments/assets/7d17c6af-79de-48d0-92d0-1a3cbe943669)

Involves checking the proper functioning of sensors (DHT22, BH1750, soil moisture, GPS), ensuring accurate data collection. Tests include sensor calibration, power stability, and connectivity validation with the ESP32 and LoRa modules.

## Timeline

![timeline](https://github.com/user-attachments/assets/7c45ab75-3128-4d48-9490-4798ff87f0d5)

## Budget

![budget](https://github.com/user-attachments/assets/f0ca03a0-1e47-428f-ae59-4e681fab9ca9)


