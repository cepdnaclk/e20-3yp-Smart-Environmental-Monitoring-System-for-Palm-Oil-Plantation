#include <Arduino.h>
#include <Wire.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <ESP8266HTTPClient.h>
#include <BH1750FVI.h>
#include <DHT.h>

// ------------------------------
// WiFi Credentials
// ------------------------------
const char* WIFI_SSID = "PeraComStudents";
const char* WIFI_PASSWORD = "abcd1234";

// ------------------------------
// Firebase Settings
// ------------------------------
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collection = "DeviceTwoData";

// ------------------------------
// Pin Configuration
// ------------------------------
#define TIPPING_BUCKET_PIN D5     // GPIO14
#define DHTPIN D6                 // GPIO12
#define DHTTYPE DHT22
#define SDA_PIN D2               // GPIO4
#define SCL_PIN D1               // GPIO5

// ------------------------------
// Sensor Instances
// ------------------------------
BH1750FVI LightSensor;
DHT dht(DHTPIN, DHTTYPE);

// Tipping bucket variables
volatile int tipCount = 0;
unsigned long lastTipTime = 0;
const unsigned long debounceDelay = 500; // in ms

// ISR for tipping bucket
void IRAM_ATTR detectTip() {
  unsigned long currentTime = millis();
  if ((currentTime - lastTipTime) > debounceDelay) {
    tipCount++;
    lastTipTime = currentTime;
  }
}

// ------------------------------
// Send to Firestore
// ------------------------------
void sendToFirestore(int count, float lux, float temp, float humidity) {
  WiFiClientSecure client;
  client.setInsecure();  // Accept all SSL certificates (for dev only)

  HTTPClient https;
  String url = "https://firestore.googleapis.com/v1/projects/" + String(firebaseProjectId) +
               "/databases/(default)/documents/" + String(collection) +
               "?key=" + String(apiKey);

  if (https.begin(client, url)) {
    https.addHeader("Content-Type", "application/json");

    String payload = "{\"fields\": {"
                     "\"temperature\": {\"doubleValue\": \"" + String(temp) + "\"}, "
                     "\"humidity\": {\"doubleValue\": \"" + String(humidity) + "\"}, "
                     "\"tipCount\": {\"integerValue\": \"" + String(count) + "\"}, "
                     "\"lux\": {\"doubleValue\": \"" + String(lux, 2) + "\"}"
                     "}}";

    int httpResponseCode = https.POST(payload);
    if (httpResponseCode > 0) {
      Serial.print("Data sent to Firestore. HTTP Response code: ");
      Serial.println(httpResponseCode);
      Serial.println(https.getString());
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

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Connected!");

  // Initialize I²C (BH1750)
  Wire.begin(SDA_PIN, SCL_PIN);

  // Init BH1750
  if (LightSensor.begin()) {
    Serial.println("BH1750 initialized successfully.");
  } else {
    Serial.println("Error initializing BH1750.");
  }

  // Init DHT22
  dht.begin();
  Serial.println("DHT22 initialized.");

  // Init tipping bucket
  pinMode(TIPPING_BUCKET_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(TIPPING_BUCKET_PIN), detectTip, FALLING);
  Serial.println("Tipping bucket sensor ready.");
}

void loop() {
  // Read tipping bucket count
  int currentTipCount = tipCount;
  Serial.print("Tipping Count: ");
  Serial.println(currentTipCount);

  // Read BH1750 light sensor
  float lux = LightSensor.readLightLevel();
  Serial.print("Light: ");
  Serial.print(lux);
  Serial.println(" lx");

  // Read DHT22
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("Failed to read from DHT22!");
  } else {
    Serial.print("Temperature: ");
    Serial.print(temperature);
    Serial.print(" °C, Humidity: ");
    Serial.print(humidity);
    Serial.println(" %");
  }

  // Send all data to Firestore
  sendToFirestore(currentTipCount, lux, temperature, humidity);

  delay(7000);  // Wait before next upload
}
