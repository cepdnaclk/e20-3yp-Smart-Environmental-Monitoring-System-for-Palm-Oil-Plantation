#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <ESP8266HTTPClient.h>
#include <Wire.h>
#include <BH1750FVI.h>

// ------------------------------
// Tipping Bucket Sensor Settings
// ------------------------------
const int sensorPin = D5;            // Hall sensor input for the tipping bucket (use D5 to avoid I²C conflicts)
volatile int tipCount = 0;           // Counter for bucket tips
unsigned long lastTipTime = 0;       // For debounce timing
const unsigned long debounceDelay = 500; // 500 milliseconds debounce

// Interrupt Service Routine for the tipping bucket sensor
void IRAM_ATTR detectTip() {
  unsigned long currentTime = millis();
  if ((currentTime - lastTipTime) > debounceDelay) {
    tipCount++;
    lastTipTime = currentTime;
  }
}

// ------------------------------
// BH1750 Light Sensor Settings
// ------------------------------
// Create the BH1750 sensor instance using the BH1750FVI library.
// We use the default constructor, which (when the ADDR pin is not connected)
// assumes the low I²C address (0x23).
BH1750FVI LightSensor;

// ------------------------------
// WiFi and Firestore Settings
// ------------------------------
const char* WIFI_SSID = "Eng-Student";
const char* WIFI_PASSWORD = "3nG5tuDt";

// Firestore configuration: replace these with your actual project values
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collection = "DeviceTwoData";

// Function to send the current tip count and light level to Firestore using HTTPS POST
void sendToFirestore(int count, float lux) {
  WiFiClientSecure client;
  client.setInsecure();  // For testing only; in production, validate SSL certificates

  HTTPClient https;
  // Construct Firestore REST API URL:
  String url = "https://firestore.googleapis.com/v1/projects/" + String(firebaseProjectId) +
               "/databases/(default)/documents/" + String(collection) +
               "?key=" + String(apiKey);

  if (https.begin(client, url)) {
    https.addHeader("Content-Type", "application/json");

    // Construct JSON payload:
    // { "fields": { "tipCount": { "integerValue": "count" }, "lux": { "doubleValue": "lux" } } }
    String payload = "{\"fields\": {\"tipCount\": {\"integerValue\": \"" + String(count) +
                     "\"}, \"lux\": {\"doubleValue\": \"" + String(lux, 2) + "\"}}}";

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

  // ------------------------------
  // Setup Tipping Bucket Sensor
  // ------------------------------
  pinMode(sensorPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(sensorPin), detectTip, FALLING);

  // ------------------------------
  // Connect to WiFi
  // ------------------------------
  Serial.print("Connecting to WiFi");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Connected!");

  // ------------------------------
  // Initialize BH1750 Light Sensor
  // ------------------------------
  // For NodeMCU, default I²C pins are: SDA -> D2, SCL -> D1.
  Wire.begin();
  if (LightSensor.begin()) {
    Serial.println("BH1750 initialized successfully.");
  } else {
    Serial.println("Error initializing BH1750.");
  }
  Serial.println("Tipping bucket gauge ready.");

}

void loop() {

  
  // When tip count changes, read the light sensor and send data to Firestore.
  // if (lastPrintedCount != tipCount) {
  // int lastPrintedCount = tipCount;
  // Serial.print("Bucket tips detected: ");
  Serial.println(tipCount);

  // Read light level from BH1750
  float lux = LightSensor.readLightLevel();
  Serial.print("Light: ");
  Serial.print(lux);
  Serial.println(" lx");


  // Send both values to Firestore
  sendToFirestore(tipCount, lux);

  delay(7000);
}