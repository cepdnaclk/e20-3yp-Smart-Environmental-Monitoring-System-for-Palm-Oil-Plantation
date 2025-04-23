#include <Wire.h>
#include <BH1750FVI.h>
#include <Arduino.h>

BH1750FVI LightSensor;  // Use the default constructor

void setup() {
  Serial.begin(9600);
  Wire.begin();         // Initialize I2C (for ESP8266, default pins are used or can be specified)
  
  // Begin sensor operation; this will use the default address (0x23 when ADDR is not connected)
  if (LightSensor.begin()) {
    Serial.println("BH1750 initialized successfully.");
  } else {
    Serial.println("Error initializing BH1750.");
  }
  
  Serial.println("Running...");
}

void loop() {
  // Use the library's API to read light intensity.
  // In this version the function is named readLightLevel() and returns a float.
  float lux = LightSensor.readLightLevel();
  Serial.print("Light: ");
  Serial.print(lux);
  Serial.println(" lx");
  delay(250);
}