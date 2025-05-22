#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>  // MQTT Library
#include <Wire.h>
#include <BH1750FVI.h>

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
// BH1750 Light Sensor Settings
// ------------------------------
BH1750FVI LightSensor;

// ------------------------------
// WiFi Settings
// ------------------------------
const char* WIFI_SSID = "Eng-Student";
const char* WIFI_PASSWORD = "3nG5tuDt";

// ------------------------------
// MQTT Settings (Mosquitto Broker)
// ------------------------------
const char* mqttServer = "your-mosquitto-broker.com"; // Replace with your Mosquitto broker address
const int mqttPort = 8883; // Port for MQTT over TLS (default is 8883)
const char* mqttUser = "your-mqtt-username"; // Replace with your MQTT username
const char* mqttPassword = "your-mqtt-password"; // Replace with your MQTT password

const char* mqttTopicTips = "sensor/tipCount";
const char* mqttTopicLux = "sensor/lux";

WiFiClientSecure espClient;  // Secure client for TLS
PubSubClient client(espClient); 

// ------------------------------
// Connect to WiFi
// ------------------------------
void connectWiFi() {
  Serial.print("Connecting to WiFi...");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Connected!");
}

// ------------------------------
// Connect to MQTT Broker (with TLS)
// ------------------------------
void connectMQTT() {
  espClient.setInsecure();  // WARNING: For testing only; replace with proper certificates in production
  
  client.setServer(mqttServer, mqttPort);

  while (!client.connected()) {
    Serial.print("Connecting to MQTT...");
    if (client.connect("ESP8266Client", mqttUser, mqttPassword)) {
      Serial.println(" Connected to MQTT broker!");
    } else {
      Serial.print(" Failed, retrying in 5s... ");
      Serial.println(client.state());
      delay(5000);
    }
  }
}

// ------------------------------
// Publish Sensor Data to MQTT
// ------------------------------
void publishData() {
  float lux = LightSensor.readLightLevel();
  
  // Convert to JSON format for MQTT payload
  String tipPayload = "{\"tipCount\": " + String(tipCount) + "}";
  String luxPayload = "{\"lux\": " + String(lux, 2) + "}";

  // Publish data to respective topics
  if (client.publish(mqttTopicTips, tipPayload.c_str())) {
    Serial.println("Sent tip count to MQTT.");
  } else {
    Serial.println("Failed to send tip count.");
  }

  if (client.publish(mqttTopicLux, luxPayload.c_str())) {
    Serial.println("Sent lux data to MQTT.");
  } else {
    Serial.println("Failed to send lux data.");
  }
}

void setup() {
  Serial.begin(9600);
  
  pinMode(sensorPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(sensorPin), detectTip, FALLING);

  connectWiFi();
  connectMQTT();

  Wire.begin();
  if (LightSensor.begin()) {
    Serial.println("BH1750 initialized.");
  } else {
    Serial.println("BH1750 initialization failed.");
  }
}

void loop() {
  if (!client.connected()) {
    connectMQTT();
  }
  
  client.loop(); // Maintain MQTT connection

  Serial.print("Bucket tips detected: ");
  Serial.println(tipCount);

  Serial.print("Light: ");
  Serial.print(LightSensor.readLightLevel());
  Serial.println(" lx");

  publishData();

  delay(7000);
}
