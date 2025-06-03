#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <ESP8266HTTPClient.h>
#include <Wire.h>
#include <BH1750FVI.h>
#include <DHT.h>
#include <LiquidCrystal_I2C.h>

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

//DHT22 pin definition
#define DHTPIN D6
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);

// ------------------------------
// WiFi and Firestore Settings
// ------------------------------
const char* WIFI_SSID = "Galaxy A32 New";
// const char* WIFI_SSID = "Dialog 4G";
const char* WIFI_PASSWORD = "ishan011";
// #define WIFI_PASSWORD "J63E5AH8Q2B"

// Firestore configuration: replace these with your actual project values
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collectionforTippingBucket = "raw_rain_data";
const char* collectionLuxTempHum = "lux_level";


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


  // Init DHT22
  dht.begin();
  Serial.println("DHT22 initialized.");

  // Initialize I2C and LCD
  lcd.init();  // or lcd.begin() depending on the library version
  lcd.backlight();  // Turn on the backlight

  // Display text on the LCD
  lcd.setCursor(0, 0);  // Column 0, Row 0
  lcd.print("Hello, ESP32!");
  
  lcd.setCursor(0, 1);  // Column 0, Row 1
  lcd.print("LCD Working :)");

  // Initialize time (for timestamp)
  configTime(0, 0, "pool.ntp.org");
}

// Function to send the current tip count to Firestore using HTTPS POST
void sendRainToFirestore(int count) {
  WiFiClientSecure client;
  client.setInsecure();  // For testing only; in production, validate SSL certificates

  HTTPClient https;
  // Construct Firestore REST API URL:
  String url = "https://firestore.googleapis.com/v1/projects/" + String(firebaseProjectId) +
               "/databases/(default)/documents/" + String(collectionforTippingBucket) +
               "?key=" + String(apiKey);

  if (https.begin(client, url)) {
    https.addHeader("Content-Type", "application/json");

    //Get current time
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) {
      Serial.println("Failed to obtain time");
      return;
    }
    char timestamp[30];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);

    // Construct JSON payload:
    String payload = "{\"fields\": {\"tipCount\": {\"integerValue\": \"" + String(count) + "\"}, "
                    "\"timestamp\": {\"timestampValue\": \"" + String(timestamp) + "\"} "
                      "}}";

    int httpResponseCode = https.POST(payload);
    if (httpResponseCode > 0) {
      Serial.print("Rain Data sent to Firestore. HTTP Response code: ");
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

// Function to send the light level, temperature and humidity to Firestore using HTTPS POST
void sendLuxToFirestore(float lux, float temperature, float humidity) {
  WiFiClientSecure client;
  client.setInsecure();  // For testing only; in production, validate SSL certificates

  HTTPClient https;
  // Construct Firestore REST API URL:
  String url = "https://firestore.googleapis.com/v1/projects/" + String(firebaseProjectId) +
               "/databases/(default)/documents/" + String(collectionLuxTempHum) +
               "?key=" + String(apiKey);

  if (https.begin(client, url)) {
    https.addHeader("Content-Type", "application/json");

    //Get current time
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) {
      Serial.println("Failed to obtain time");
      return;
    }
    char timestamp[30];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);

    // Construct JSON payload:
    String payload = "{\"fields\": {"
                     "\"temperature\": {\"doubleValue\": \"" + String(temperature) + "\"}, "
                     "\"humidity\": {\"doubleValue\": \"" + String(humidity) + "\"}, "
                     "\"lux\": {\"doubleValue\": \"" + String(lux, 2) + "\"}, "
                     "\"timestamp\": {\"timestampValue\": \"" + String(timestamp) + "\"}"
                     "}}";

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



void loop() {

  
  // When tip count changes, read the light sensor and send data to Firestore.
  // if (lastPrintedCount != tipCount) {
  // int lastPrintedCount = tipCount;
  // Serial.print("Bucket tips detected: ");
  Serial.println(tipCount);

  // Read DHT22
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  // Read light level from BH1750
  float lux = LightSensor.readLightLevel();
  Serial.print("Light: ");
  Serial.print(lux);
  Serial.println(" lx");


  // Send both values to Firestore
  sendRainToFirestore(tipCount);
  delay(10000);
  sendLuxToFirestore(lux, temperature, humidity);

  delay(7000);
}