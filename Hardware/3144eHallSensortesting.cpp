#include <Arduino.h>
#include <WiFiMulti.h>


// put function declarations here:
//int myFunction(int, int);

#define LED_BUILTIN 2
#define WIFI_SSID "Dialog 4G"
#define WIFI_PASSWORD "J63E5AH8Q2B"
#define SENSOR_PIN 21

//Wifi instance
WiFiMulti wifiMulti;



void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  pinMode(SENSOR_PIN, INPUT);
  Serial.println("3144e Hall Sensor Initialized!");
  
  pinMode(LED_BUILTIN, OUTPUT);
  

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

  int state = digitalRead(SENSOR_PIN);
    
  if (state == LOW) {  // When magnet is near
    Serial.println("Bucket tipped! (Magnet detected)");
  } else {
    Serial.println("No tipping event");
  }

  digitalWrite(LED_BUILTIN, HIGH);
  delay(400);
  digitalWrite(LED_BUILTIN, LOW);
  delay(400);
}



// put function definitions here:
// int myFunction(int x, int y) {
//   return x + y;
// }