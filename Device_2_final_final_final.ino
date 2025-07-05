#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <ESP8266HTTPClient.h>
#include <Wire.h>
#include <DHT.h>
#include <LiquidCrystal_I2C.h>
#include <time.h>

// ------------------------------
// Tipping Bucket Sensor Settings
// ------------------------------
const int sensorPin = D5;
volatile int tipCount = 0;
unsigned long lastTipTime = 0;
const unsigned long debounceDelay = 500;

void IRAM_ATTR detectTip() {
  unsigned long currentTime = millis();
  if ((currentTime - lastTipTime) > debounceDelay) {
    tipCount++;
    lastTipTime = currentTime;
  }
}

// ------------------------------
// Sensor + LCD Setup
// ------------------------------
#define DHTPIN D6
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

LiquidCrystal_I2C lcd(0x27, 16, 2);

// ------------------------------
// WiFi Configuration
// ------------------------------
#define WiFi_2_SSID "Galaxy A32 New"
#define PASSWORD2 "ishan011"

const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collectionforTippingBucket = "raw_rain_data";
const char* collectionLuxTempHum = "lux_level";

// ------------------------------
// Setup
// ------------------------------
void setup() {
  Serial.begin(9600);
  pinMode(sensorPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(sensorPin), detectTip, FALLING);

  // Initialize I2C for LCD
  Wire.begin(D2, D1);
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Starting...");
  delay(1000);

  // DHT sensor
  dht.begin();
  Serial.println("DHT22 initialized.");

  // Random seed for simulating lux
  randomSeed(analogRead(A0));

  // WiFi
  Serial.print("Connecting to WiFi");
  WiFi.begin(WiFi_2_SSID, PASSWORD2);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" connected.");

  // NTP time
  configTime(0, 0, "pool.ntp.org");
}

// ------------------------------
// Firestore Upload Functions
// ------------------------------
void sendRainToFirestore(int count) {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Uploading rain data");
  lcd.setCursor(0, 1);
  lcd.print("to firestore...");

  WiFiClientSecure client;
  client.setInsecure();
  HTTPClient https;

  String url = "https://firestore.googleapis.com/v1/projects/" + String(firebaseProjectId) +
               "/databases/(default)/documents/" + String(collectionforTippingBucket) +
               "?key=" + String(apiKey);

  if (https.begin(client, url)) {
    https.addHeader("Content-Type", "application/json");

    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) {
      Serial.println("Failed to obtain time");
      return;
    }
    char timestamp[30];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);

    String payload = "{\"fields\": {\"tipCount\": {\"integerValue\": \"" + String(count) +
                     "\"}, \"timestamp\": {\"timestampValue\": \"" + String(timestamp) + "\"}}}";

    int httpResponseCode = https.POST(payload);
    if (httpResponseCode > 0) {
      Serial.print("Rain data sent. Code: ");
      Serial.println(httpResponseCode);
      Serial.println(https.getString());
    } else {
      Serial.print("Error: ");
      Serial.println(https.errorToString(httpResponseCode));
    }
    https.end();
  }

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Rain data Uploaded.");
  delay(500);
}

void sendLuxToFirestore(float lux, float temperature, float humidity) {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Uploading lux,temp,");
  lcd.setCursor(0, 1);
  lcd.print("humid to firestore...");

  WiFiClientSecure client;
  client.setInsecure();
  HTTPClient https;

  String url = "https://firestore.googleapis.com/v1/projects/" + String(firebaseProjectId) +
               "/databases/(default)/documents/" + String(collectionLuxTempHum) +
               "?key=" + String(apiKey);

  if (https.begin(client, url)) {
    https.addHeader("Content-Type", "application/json");

    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) {
      Serial.println("Failed to obtain time");
      return;
    }
    char timestamp[30];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);

    String payload = "{\"fields\": {"
                     "\"temperature\": {\"doubleValue\": \"" + String(temperature, 1) + "\"}, "
                     "\"humidity\": {\"doubleValue\": \"" + String(humidity, 1) + "\"}, "
                     "\"lux\": {\"doubleValue\": \"" + String(lux, 2) + "\"}, "
                     "\"timestamp\": {\"timestampValue\": \"" + String(timestamp) + "\"}}}";

    int httpResponseCode = https.POST(payload);
    if (httpResponseCode > 0) {
      Serial.print("Lux data sent. Code: ");
      Serial.println(httpResponseCode);
      Serial.println(https.getString());
    } else {
      Serial.print("Error: ");
      Serial.println(https.errorToString(httpResponseCode));
    }
    https.end();
  }

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Data Uploaded.");
  delay(500);
}

// ------------------------------
// Loop
// ------------------------------
void loop() {
  if (WiFi.status() != WL_CONNECTED) {
    WiFi.begin(WiFi_2_SSID, PASSWORD2);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("WiFi reconnecting...");
    delay(2000);
    return;
  }

  // Tipping bucket
  Serial.print("Tips: ");
  Serial.println(tipCount);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Tips: ");
  lcd.print(tipCount);

  sendRainToFirestore(tipCount);
  delay(10000);

  // Simulated lux and real DHT22
  float lux = random(200, 301);
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  Serial.print("Lux: "); Serial.println(lux);
  Serial.print("Temp: "); Serial.println(temperature);
  Serial.print("Humidity: "); Serial.println(humidity);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Lux:");
  lcd.print(lux, 0);
  delay(2000);
  lcd.setCursor(0, 1);
  lcd.print("Temp:");
  lcd.print(temperature, 1);
  delay(2000);

  lcd.setCursor(0, 0);
  lcd.print("Humid:");
  lcd.print(humidity, 1);
  lcd.print("%");
  delay(2000);

  sendLuxToFirestore(lux, temperature, humidity);

  delay(7000);
}
