#include <Arduino.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include <DHT.h>
#include <LiquidCrystal_I2C.h>
#include <time.h>


#define LED_BUILTIN 2
#define WIFI_SSID "Dialog 4G"
#define WIFI_PASSWORD "J63E5AH8Q2B"

//Firebase project credentials
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collection = "sensorData"; // Firestore collection name

//DHT22 module initialization
#define DHTPIN 26
#define DHTTYPE DHT22

//DHT sensor instance
DHT dht(DHTPIN, DHTTYPE);

//Wifi instance
WiFiMulti wifiMulti;

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);




void setup() {
  // put your setup code here, to run once:
  Serial.begin(921600);
  
  pinMode(LED_BUILTIN, OUTPUT);


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
  delay(2000);
}

void loop(){
  //Put your main code here, to run repeatedly:
  delay(100);
  digitalWrite(LED_BUILTIN, WiFi.status() == WL_CONNECTED); // LED on if wifi is connected


  float temp = dht.readTemperature();
  float humidity = dht.readHumidity();

  // Get current time
  time_t now;
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Failed to obtain time");
    return;
  }
  char timestamp[30];
  strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);

  if(isnan(temp) || isnan(humidity)){
    Serial.println("Failed to read from DHT sensor!");
    lcd.clear();
    lcd.print("Sensor error");
    delay(2000);
    return;
  }

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

  delay(5000);
}
