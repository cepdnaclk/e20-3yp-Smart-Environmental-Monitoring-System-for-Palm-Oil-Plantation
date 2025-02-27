#include <Arduino.h>
#include <WiFiMulti.h>


// put function declarations here:
//int myFunction(int, int);

#define LED_BUILTIN 2
#define WIFI_SSID "Dialog 4G"
#define WIFI_PASSWORD "J63E5AH8Q2B"
#define MOISTURE_SENSOR_PIN 34

const int dry = 2680; // value for dry sensor
const int wet = 1100; // value for wet sensor

//Wifi instance
WiFiMulti wifiMulti;



void setup() {
  // put your setup code here, to run once:
  Serial.begin(921600);

  
  Serial.println("Capacitive soil moisture Sensor Initialized!");
  
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(MOISTURE_SENSOR_PIN, INPUT);
  

  //Connect to WiFi 
  // wifiMulti.addAP(WIFI_SSID, WIFI_PASSWORD);
  // while(wifiMulti.run() != WL_CONNECTED){
  //   delay(100);
  // }
  // Serial.println("WiFi connected");
}

void loop(){
  // put your main code here, to run repeatedly:
  // delay(100);
  // digitalWrite(LED_BUILTIN, WiFi.status() == WL_CONNECTED); // LED on if wifi is connected
  //Serial.println("Hello, World loop!");

  //Serial.println(analogRead(MOISTURE_SENSOR_PIN));

  int sensorValue = analogRead(MOISTURE_SENSOR_PIN);
    
  // Convert raw ADC value (0-4095) to percentage
  float moisturePercent = map(sensorValue, wet, dry, 100, 0);  

  Serial.print("Moisture Level: ");
  Serial.print(moisturePercent);
  Serial.println("%");

  digitalWrite(LED_BUILTIN, HIGH);
  delay(400);
  digitalWrite(LED_BUILTIN, LOW);
  delay(400);
}



// put function definitions here:
// int myFunction(int x, int y) {
//   return x + y;
// }