#include <Arduino.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include <DHT.h>
#include <TinyGPS++.h>
#include <LiquidCrystal_I2C.h>
#include <PubSubClient.h>
#include <time.h>
#include <Wire.h>


#define LED_BUILTIN 2

//Wifi credentials
#define WIFI_SSID "Eng-Student"
//#define WIFI_PASSWORD "J63E5AH8Q2B"
#define WIFI_PASSWORD "3nG5tuDt"

// MQTT broker details
const char* MQTT_BROKER = "your-mosquitto-broker.com";
const int MQTT_PORT = 8883; // TLS port
const char* MQTT_TOPIC = "sensor/data";

// TLS certificates
const char* MQTT_CA_CERT = 
"-----BEGIN CERTIFICATE-----\n"
"MIIDXTCCAkWgAwIBAgIJAO+S2zPoq/MpMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV\n"
"BAYTAkFVMSUwIwYDVQQKExxFeGFtcGxlIENlcnRpZmljYXRlIEF1dGhvcml0eTEM\n"
"MAoGA1UEAxMDQ0EwHhcNMTgwNzEwMTAwMDAwWhcNMjgwNzA4MTAwMDAwWjBFMQsw\n"
"CQYDVQQGEwJBVTElMCMGA1UEChMcRXhhbXBsZSBDZXJ0aWZpY2F0ZSBBdXRob3Jp\n"
"Gj6hFk4vHzZ1W9DB9IT2BA==\n"
"-----END CERTIFICATE-----";

// Create WiFi and MQTT clients
WiFiClientSecure espClient;
PubSubClient client(espClient);

//DHT22 pin definition
#define DHTPIN 26
#define DHTTYPE DHT22

//BH1750 address definition
// #define BH1750_I2C_ADDRESS 0x23  //I2C address of BH1750

//Capacitive Soil Moisture sensor pin definition
#define MOISTURE_SENSOR_PIN 34
const int dry = 2750; // value for dry sensor
const int wet = 970; // value for wet sensor

//Firebase project credentials
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collection = "SensorData"; // Firestore collection name



//DHT sensor instance
DHT dht(DHTPIN, DHTTYPE);

//BH1750 sensor instance
// TwoWire I2Cwire = TwoWire(0);
// BH1750_WE lightMeter(BH1750_I2C_ADDRESS);

//GPS instance
TinyGPSPlus gps;
HardwareSerial gpsSerial(2); //Use UART2

//Wifi instance
WiFiMulti wifiMulti;

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);



void connectToMQTT() {
    espClient.setCACert(MQTT_CA_CERT); // Set TLS certificate
    client.setServer(MQTT_BROKER, MQTT_PORT);

    while (!client.connected()) {
        Serial.print("Connecting to MQTT broker...");
        if (client.connect("ESP32Client")) {
            Serial.println(" connected.");
        } else {
            Serial.print(" failed, rc=");
            Serial.print(client.state());
            Serial.println(" retrying in 5 seconds...");
            delay(5000);
        }
    }
}


void setup() {
    // put your setup code here, to run once:
    Serial.begin(921600);
    
    pinMode(LED_BUILTIN, OUTPUT);

    Wire.begin(21, 22); // SDA, SCL

    // Initialize I2C and LCD
    lcd.init();  // or lcd.begin() depending on the library version
    lcd.backlight();  // Turn on the backlight

    // Display text on the LCD
    lcd.setCursor(0, 0);  // Column 0, Row 0
    lcd.print("Hello, ESP32!");
    
    lcd.setCursor(0, 1);  // Column 0, Row 1
    lcd.print("LCD Working :)");

    
    //Connect to WiFi 
    wifiMulti.addAP(WIFI_SSID, WIFI_PASSWORD);
    while(wifiMulti.run() != WL_CONNECTED){
        delay(100);
    }
    Serial.println("WiFi connected");


    // Initialize time (for timestamp)
    configTime(0, 0, "pool.ntp.org");

    //Begin DHT sensor
    dht.begin();

    //Begin BH1750 sensor
    // if(!lightMeter.init()){
    //   Serial.println("BH1750 Sensor not found!");
    //   while (1);
    // }
    // Serial.println("BH1750 Sensor Initialized!");

    //Begin Capacitive Soil Moisture sensor
    pinMode(MOISTURE_SENSOR_PIN, INPUT);
    Serial.println("Capacitive soil moisture Sensor Initialized!");

    //Begin Neo-6M GPS sensor
    gpsSerial.begin(9600, SERIAL_8N1, 16, 17);
    Serial.println("NEO-6M Sensor Initialized!");
    

    delay(2000);
    connectToMQTT();
}

void loop() {
    if (!client.connected()) {
        connectToMQTT();
    }
    client.loop();
    //Put your main code here, to run repeatedly:
    delay(100);
    digitalWrite(LED_BUILTIN, WiFi.status() == WL_CONNECTED); // LED on if wifi is connected

    //-------------------------------
    //DHT22 Sensor data reading
    //-------------------------------

    //Get DHT22 sensor readings
    float temp = dht.readTemperature();
    float humidity = dht.readHumidity();

    if(isnan(temp) || isnan(humidity)){
        Serial.println("Failed to read from DHT sensor!");
        lcd.clear();
        lcd.print("Sensor error");
        delay(2000);
        return;
    }

    //Sensor data writing to Serial Monitor
    Serial.print("Temperature: ");
    Serial.print(temp);
    Serial.print("C, Humidity: ");
    Serial.print(humidity);
    Serial.println("%");


    // Display data on LCD
    lcd.clear();
    lcd.setCursor(0, 0); // first row
    lcd.print("Temp: ");
    lcd.print(temp);
    lcd.print(" C");

    lcd.setCursor(0, 1); // second row
    lcd.print("Hum: ");
    lcd.print(humidity);
    lcd.print(" %");

    delay(2000);

    //-------------------------------
    //DHT22 Sensor data reading
    //-------------------------------

    //Get BH1750 sensor readings
    // float lux = lightMeter.getLux();

    // //Sensor data writing to Serial Monitor
    // Serial.print("Light Intensity: ");
    // Serial.print(lux);
    // Serial.println(" lx");

    //-------------------------------
    //Capacitive Soil Moisture Sensor data reading
    //-------------------------------

    //Get Capacitive Soil Moisture sensor readings
    int sensorValue = analogRead(MOISTURE_SENSOR_PIN);
    float moisturePercent = map(sensorValue, wet, dry, 100, 0);  //Convert raw ADC value (0-4095) to percentage

    //Sensor data writing to Serial Monitor
    Serial.print("Moisture Level: ");
    Serial.print(moisturePercent);
    Serial.println("%");

    //Display data on LCD
    lcd.clear();
    lcd.setCursor(0, 0); // first row
    lcd.print("Moist: ");
    lcd.print(moisturePercent);
    lcd.print(" %");

    // lcd.setCursor(0, 1); // second row
    // lcd.print("Moist: ");
    // lcd.print(moisturePercent);
    // lcd.print(" %");

    delay(2000);


    //-------------------------------
    //Neo-6M Sensor data reading
    //-------------------------------

    //Get GPS sensor readings
    float Lati = 0.0;
    float Longi = 0.0;
    gps.encode(gpsSerial.read());

    //Sensor data writing to Serial Monitor
    if (gps.location.isUpdated()) {  // If new data is available
        Serial.print("Latitude: ");
        Lati = gps.location.lat();
        Serial.println(gps.location.lat(), 6);

        Serial.print("Longitude: ");
        Longi = gps.location.lng();
        Serial.println(gps.location.lng(), 6);

        Serial.print("Altitude: ");
        Serial.println(gps.altitude.meters());

        Serial.print("Speed: ");
        Serial.println(gps.speed.kmph());
    }
    Serial.println("----------------------");

    //Display data on LCD
    lcd.clear();
    lcd.setCursor(0, 0); // first row
    lcd.print("Lati: ");
    lcd.print(Lati, 6);

    lcd.setCursor(0, 1); // second row
    lcd.print("Longi: ");
    lcd.print(Longi, 6);


    
    //Get current time
    time_t now;
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) {
        Serial.println("Failed to obtain time");
        return;
    }
    char timestamp[30];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);




    //Upload data to Firebase Firestore
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        
        String url = "https://firestore.googleapis.com/v1/projects/" + 
                    String(firebaseProjectId) + 
                    "/databases/(default)/documents/" + 
                    String(collection) + "?key=" + 
                    String(apiKey);

        http.begin(url);
        http.addHeader("Content-Type", "application/json");

        //Sample sensor data (adjust this with real sensor readings)
        String jsonPayload = R"(
        {
            "fields": {
            "temperature": {"doubleValue": )" + String(temp) + R"(},
            "humidity": {"doubleValue": )" + String(humidity) + R"(},
            "soilMoisture": {"doubleValue": )" + String(moisturePercent) + R"(},
            "latitude": {"doubleValue": 7.2538},
            "longitude": {"doubleValue": 80.5916},
            "timestamp": {"timestampValue": ")" + String(timestamp) + R"("}
            }
        }
        )";

        int httpResponseCode = http.POST(jsonPayload);
        
        if (httpResponseCode > 0) {
        Serial.print("Data sent! Response code: ");
        Serial.println(httpResponseCode);
        Serial.println(http.getString());
        } else {
        Serial.print("Error sending data: ");
        Serial.println(httpResponseCode);
        }
        
        http.end();
    }

    delay(4000);
}
