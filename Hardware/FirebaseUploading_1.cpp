#include <Arduino.h>
#include <WiFiMulti.h>
#include <FirebaseESP32.h>
#include <DHT.h>


#define LED_BUILTIN 2
#define WIFI_SSID "Eng-Student"
#define WIFI_PASSWORD "3nG5tuDt"

// Firebase project credentials
#define FIREBASE_HOST "https://environment-monitoring-s-d169b-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "LrrEzQnatrDmbbhHt82MsZRK7AxZaXf25i7N7yrL"

//DHT22 module initialization
#define DHTPIN 26
#define DHTTYPE DHT22

//DHT sensor instance
DHT dht(DHTPIN, DHTTYPE);

//Wifi instance
WiFiMulti wifiMulti;

// Initialize Firebase
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;



void setup() {
  // put your setup code here, to run once:
  Serial.begin(921600);
  
  pinMode(LED_BUILTIN, OUTPUT);
  
  //Connect to WiFi 
  wifiMulti.addAP(WIFI_SSID, WIFI_PASSWORD);
  while(wifiMulti.run() != WL_CONNECTED){
    delay(100);
  }
  Serial.println("WiFi connected");

  // Initialize Firebase
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);

  dht.begin();
  delay(2000);
}

void loop(){
  // put your main code here, to run repeatedly:
  delay(100);
  digitalWrite(LED_BUILTIN, WiFi.status() == WL_CONNECTED); // LED on if wifi is connected
  //Serial.println("Hello, World loop!");

  float temp = dht.readTemperature();
  float humidity = dht.readHumidity();
  String timestamp = String(millis());

  if(isnan(temp) || isnan(humidity)){
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  Serial.print("Temperature: ");
  Serial.print(temp);
  Serial.print("C, Humidity: ");
  Serial.print(humidity);
  Serial.println("%");


  // digitalWrite(LED_BUILTIN, HIGH);
  // delay(400);
  // digitalWrite(LED_BUILTIN, LOW);
  // delay(400);

  // Prepare JSON data
  FirebaseJson json;
  json.add("Humidity", humidity);
  json.add("Temperature", temp);
  json.add("timestamp", timestamp);

  // Store data in Firestore under /sensorData
  if (Firebase.pushJSON(fbdo, "/sensorData/DHT22", json)) {
    Serial.println("Data sent to Firestore!");
  } else {
    Serial.printf("Failed to send data: %s\n", fbdo.errorReason().c_str());
  }

  delay(3000);
}
