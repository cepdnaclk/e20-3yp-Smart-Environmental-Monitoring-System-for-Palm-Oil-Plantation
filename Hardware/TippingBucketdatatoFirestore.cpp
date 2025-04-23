#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <ESP8266HTTPClient.h>

// ESP8266 Tipping Bucket Gauge with Hall Sensor

const int sensorPin = D2;  // Hall sensor connected to GPIO4 (D2 on NodeMCU)
volatile int tipCount = 0; // Count of bucket tips

// Debounce parameters
unsigned long lastTipTime = 0;
const unsigned long debounceDelay = 500; // milliseconds, adjust if needed

// Interrupt service routine to detect a tip
void IRAM_ATTR detectTip() {
    unsigned long currentTime = millis();
    // Debounce: ignore multiple triggers within debounceDelay milliseconds
    if ((currentTime - lastTipTime) > debounceDelay) {
        tipCount++;
        lastTipTime = currentTime;
    }
}

//Wifi credentials
#define WIFI_SSID "Eng-Student"
//#define WIFI_PASSWORD "J63E5AH8Q2B"
#define WIFI_PASSWORD "3nG5tuDt"

//Firebase project credentials
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collection = "DeviceTwoData"; // Firestore collection name

// Function to send data to Firestore using the REST API
void sendToFirestore(int count) {
  // Create a secure client
  WiFiClientSecure client;
  client.setInsecure();  // For testing only; in production, validate SSL certificates
  
  HTTPClient https;
  
  // Construct the Firestore URL
  // Firestore REST endpoint: https://firestore.googleapis.com/v1/projects/your_project_id/databases/(default)/documents/your_collection?key=YOUR_API_KEY
  String url = "https://firestore.googleapis.com/v1/projects/" + String(firebaseProjectId) +
               "/databases/(default)/documents/" + String(collection) +
               "?key=" + String(apiKey);
  
  if (https.begin(client, url)) {
    https.addHeader("Content-Type", "application/json");
    
    // Create JSON payload according to Firestore structure.
    // This example updates the 'tipCount' field with the current count.
    String payload = "{\"fields\": {\"tipCount\": {\"integerValue\": \"" + String(count) + "\"}}}";
    
    int httpResponseCode = https.POST(payload);
    if (httpResponseCode > 0) {
      Serial.print("Data sent to Firestore. HTTP Response code: ");
      Serial.println(httpResponseCode);
      String response = https.getString();
      Serial.println(response);
    } else {
      Serial.print("Error sending POST request: ");
      Serial.println(https.errorToString(httpResponseCode));
    }
    https.end();
  } else {
    Serial.println("Unable to connect to Firestore endpoint.");
  }
}


void setup() {
    Serial.begin(9600);
    pinMode(sensorPin, INPUT_PULLUP); // or INPUT depending on your sensor
    attachInterrupt(digitalPinToInterrupt(sensorPin), detectTip, FALLING);

    // Connect to WiFi
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    Serial.println(" Connected!");

    Serial.println("Tipping bucket gauge ready.");
}

void loop() {
    static int lastPrintedCount = 0;
    if (lastPrintedCount != tipCount) {
        lastPrintedCount = tipCount;
        Serial.print("Bucket tips detected: ");
        Serial.println(tipCount);
        sendToFirestore(tipCount);
    }
    delay(100);
}

// The Arduino framework provides its own main() that calls setup() and loop(),
// so there's no need to define main() in this file.