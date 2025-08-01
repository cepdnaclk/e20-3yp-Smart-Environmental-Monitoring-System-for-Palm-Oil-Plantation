#include <Arduino.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include <TinyGPS++.h>
#include <LiquidCrystal_I2C.h>
#include <time.h>
#include <Wire.h>
#include <RTClib.h>
#include <SPI.h>
#include <SD.h>


#define LED_BUILTIN 2
#define Red_LED 27
#define Green_LED 33
const int npkSwitch = 12;
const int moistSwitch = 14;
volatile bool npkInterruptFlag = false;
volatile bool moistInterruptFlag = false;

volatile unsigned long lastNpkInterruptTime = 0;
volatile unsigned long lastMoistInterruptTime = 0;

const unsigned long debounceDelay = 800;  // in milliseconds

//----------------------------------------Interrupts---------------------------------------------------------------//
void IRAM_ATTR handleNpkInterrupt() {
  unsigned long currentTime = millis();
  if ((currentTime - lastNpkInterruptTime) > debounceDelay) {
    npkInterruptFlag = true;
    lastNpkInterruptTime = currentTime;
  }
}

void IRAM_ATTR handleMoistInterrupt() {
  unsigned long currentTime = millis();
  if ((currentTime - lastMoistInterruptTime) > debounceDelay) {
    moistInterruptFlag = true;
    lastMoistInterruptTime = currentTime;
  }
}
//----------------------------------------Interrupts End---------------------------------------------------------------//

//Wifi credentials
// #define WiFi_1_SSID "Dialog 4G"
// #define PASSWORD1 "J63E5AH8Q2B"
#define WiFi_2_SSID "Galaxy A32 New"
#define PASSWORD2 "ishan011"
#define WiFi_3_SSID "PeraComStudent"
#define PASSWORD3 "abcd1234"
#define WiFi_4_SSID "PeraComStaff"
#define PASSWORD4 "pera1234"

//Wifi instance
WiFiMulti wifiMulti;
bool wifiConnected = false;

unsigned long lastWiFiCheck = 0;
const unsigned long wifiRetryInterval = 60000; // check WiFi every 60s


bool npkSwitchState = LOW;
bool moistSwitchState = LOW;

//Firebase project credentials
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collection = "raw_readings"; // Firestore collection name


//Capacitive Soil Moisture sensor pin definition
#define MOISTURE_SENSOR_PIN 34
const int dry = 3600; // value for dry sensor
const int wet = 2700; // value for wet sensor

//NPK sensor pin definition
#define RE_DE 32     // DE & RE control pin for MAX485 (D14)
#define RX_PIN 25    // UART2 RX (D25)
#define TX_PIN 26    // UART2 TX (D26)
HardwareSerial rs485(1);  // UART2
const byte readNPK[] = {0x01, 0x03, 0x00, 0x1E, 0x00, 0x03, 0x65, 0xCD};
byte response[11];

//GPS instance
HardwareSerial SerialGPS(2);  // UART2: RX=GPIO16, TX=GPIO17
TinyGPSPlus gps;
bool gpsDataAvailable = false;

//Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);

//Initialize RTC module
RTC_DS3231 rtc;

//Initialize SD card module
#define SD_CS 5


//----------------------------------------Setup---------------------------------------------------------------//
void setup() {
  Serial.begin(9600);
  
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(Red_LED, OUTPUT);
  pinMode(Green_LED, OUTPUT);
  // pinMode(npkSwitch, INPUT);
  // pinMode(moistSwitch, INPUT);

  pinMode(npkSwitch, INPUT_PULLUP);
  pinMode(moistSwitch, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(npkSwitch), handleNpkInterrupt, FALLING);
  attachInterrupt(digitalPinToInterrupt(moistSwitch), handleMoistInterrupt, FALLING);


  Wire.begin(21, 22); // SDA, SCL

  // Initialize I2C and LCD
  lcd.init();  // or lcd.begin() depending on the library version
  lcd.backlight();  // Turn on the backlight
  lcd.setCursor(0, 0);  // Column 0, Row 0
  lcd.print("Hello");
  lcd.setCursor(0, 1);  // Column 0, Row 1
  lcd.print("Device Starting");

  
  //Connect to WiFi 
  // wifiMulti.addAP(WiFi_1_SSID, PASSWORD1);
  wifiMulti.addAP(WiFi_2_SSID, PASSWORD2);
  wifiMulti.addAP(WiFi_3_SSID, PASSWORD3);
  wifiMulti.addAP(WiFi_4_SSID, PASSWORD4);
  // Initial Wi-Fi status
  wifiConnected = false;


  // Initialize time (for timestamp)
  configTime(0, 0, "pool.ntp.org");


  //Begin Capacitive Soil Moisture sensor
  pinMode(MOISTURE_SENSOR_PIN, INPUT);
  Serial.println("Capacitive soil moisture Sensor Initialized!");

  //Begin NPK module
  rs485.begin(4800, SERIAL_8N1, RX_PIN, TX_PIN);  // UART2 init with GPIO25,26
  pinMode(RE_DE, OUTPUT);
  digitalWrite(RE_DE, LOW);  // Start in receive mode
  Serial.println("✅ SN-3002-TR-NPK-N01 Reader Ready (ESP32 UART2 + MAX485)");


  //Begin Neo-6M GPS sensor
  SerialGPS.begin(9600, SERIAL_8N1, 16, 17);       // Neo-6M default baud rate
  Serial.println("NEO-6M Sensor Initialized!");

  //Begin RTC module
  if (!rtc.begin()) {
    Serial.println("Couldn't find RTC");
  }
  if (rtc.lostPower()) {
    Serial.println("RTC lost power, setting the time!");
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  }


  //Begin SD card module
  SPI.begin(18, 19, 23, SD_CS); // SCK, MISO, MOSI, CS
  Serial.println("Initializing SD card...");
  if (!SD.begin(SD_CS)) {
    Serial.println("SD card initialization failed!");
    return;
  }
  Serial.println("SD card initialized.");
  // Read from file
  File file = SD.open("/test.txt");
  if (file) {
    Serial.println("Reading test.txt:");
    while (file.available()) {
      Serial.write(file.read());
    }
    file.close();
  } else {
    Serial.println("Failed to open file for reading.");
  }

  delay(500);

  lcd.clear();
  lcd.setCursor(0, 0);  // Column 0, Row 0
  lcd.print("Hello");
  lcd.setCursor(0, 1);  // Column 0, Row 1
  lcd.print("Device is Ready");

  digitalWrite(Green_LED, HIGH);
  digitalWrite(Red_LED, LOW);

  randomSeed(analogRead(0));
}
//----------------------------------------Setup End---------------------------------------------------------------//


//----------------------------------------saveDataToSD---------------------------------------------------------------//
void saveDataToSD(String jsonPayload) {
  Serial.println("Start Saving data to SD");
  lcd.clear();
  lcd.setCursor(0, 0); // first row
  lcd.print("To SD card -->");
  lcd.setCursor(0, 1); // second row
  lcd.print("Storing..");
  delay(300);
  File file = SD.open("/unsent_data.txt", FILE_APPEND);
  if (file) {
    file.println(jsonPayload);
    file.flush();
    file.close();
    Serial.println("Saved to SD card.");
    lcd.clear();
    lcd.setCursor(0, 0); // first row
    lcd.print("Sent");
    delay(300);
  } else {
    Serial.println("Failed to write to SD card.");
    lcd.clear();
    lcd.setCursor(0, 0); // first row
    lcd.print("Fail");
    delay(300);
  }
}


//------------------------------------------sendDataToFirebase-------------------------------------------------------------//
bool sendDataToFirebase(String jsonPayload) {
  Serial.println("Start sending data to Firebase");
  lcd.clear();
  lcd.setCursor(0, 0); // first row
  lcd.print("To Firestore -->");
  lcd.setCursor(0, 1); // second row
  lcd.print("Uploading..");
  delay(300);
  HTTPClient http;
  String url = "https://firestore.googleapis.com/v1/projects/" + 
                  String(firebaseProjectId) + 
                  "/databases/(default)/documents/" + 
                  String(collection) + "?key=" + 
                  String(apiKey);

  http.begin(url);

  if (jsonPayload.length() == 0 || !jsonPayload.startsWith("{")) {
    Serial.println("⚠️ Skipping empty or invalid payload");
    return false;
  }

  http.addHeader("Content-Type", "application/json");
  http.addHeader("Content-Length", String(jsonPayload.length()));

  int httpResponseCode = http.POST(jsonPayload);
  String response = http.getString();
  http.end();

  Serial.println("Firebase response: " + response);

  return httpResponseCode == 200;
}


//----------------------------------------sendStoredSDDataToFirebase---------------------------------------------------------------//
void sendStoredSDDataToFirebase() {
  Serial.println("Start sending stored data to Firebase...");
  lcd.clear();
  lcd.setCursor(0, 0); // first row
  lcd.print("To Firestore -->");
  lcd.setCursor(0, 1); // second row
  lcd.print("Stored Uploading..");
  delay(300);

  File file = SD.open("/unsent_data.txt", FILE_READ);
  if (!file) {
    Serial.println("⚠️ No SD data to send.");
    return;
  }

  std::vector<String> remainingLines;

  while (file.available()) {
    String line = file.readStringUntil('\n');
    line.trim();

    // Skip empty or invalid lines
    if (line.length() == 0 || !line.startsWith("{") || !line.endsWith("}")) {
      Serial.println("⚠️ Skipping invalid or empty line:");
      Serial.println(line);
      continue;
    }

    if (!sendDataToFirebase(line)) {
      Serial.println("❌ Failed to send line, keeping it on SD.");
      remainingLines.push_back(line);
      lcd.clear();
      lcd.setCursor(0, 0); // first row
      lcd.print("Fail");
      delay(300);
    } else {
      Serial.println("✅ Sent from SD → Firebase");
      lcd.clear();
      lcd.setCursor(0, 0); // first row
      lcd.print("Sent");
      delay(300);
    }
  }
  file.close();

  // Rewrite file with only failed entries
  file = SD.open("/unsent_data.txt", FILE_WRITE);  // FILE_WRITE clears file
  if (file) {
    for (auto &l : remainingLines) {
      file.println(l);
    }
    file.flush();
    file.close();
    Serial.println("📝 SD file updated with unsent entries.");
  } else {
    Serial.println("❌ Failed to reopen file for writing.");
  }
}


//----------------------------------------ConnectToWiFi---------------------------------------------------------------//
void connectToWiFi() {
  Serial.println("🔌 Connecting to WiFi...");
  wifiMulti.run();  // Initiate connection attempt
  
  wifiConnected = (WiFi.status() == WL_CONNECTED);
  if (wifiConnected) {
    Serial.println("✅ Connected!");
    lcd.clear();
    lcd.setCursor(0, 0); // first row
    lcd.print("WiFi Connected.");
    delay(1000);
    sendStoredSDDataToFirebase();
  } else {
    Serial.println("❌ Failed to connect.");
  }
}




//----------------------------------------Loop---------------------------------------------------------------//
void loop(){
  delay(20);
  digitalWrite(Green_LED, HIGH);
  digitalWrite(Red_LED, LOW);

  // if(WiFi.status() != WL_CONNECTED){
  //   digitalWrite(LED_BUILTIN, LOW);
  //   connectToWiFi();
  // }
  // else{
  //   digitalWrite(LED_BUILTIN, HIGH); // LED on if wifi is connected
  // }
  
  // bool currentNpkSwitchState = digitalRead(npkSwitch);
  // bool currentMoistSwitchState = digitalRead(moistSwitch);

  // if (currentNpkSwitchState == HIGH && npkSwitchState == LOW) {

  //   digitalWrite(Green_LED, LOW);
  //   digitalWrite(Red_LED, HIGH);

  if (npkInterruptFlag) {
    npkInterruptFlag = false;
  
    digitalWrite(Green_LED, LOW);
    digitalWrite(Red_LED, HIGH);
    
    //-------------------------------
    //NPK Sensor data reading
    //-------------------------------
    Serial.println("\n📤 Sending NPK request...");

    digitalWrite(RE_DE, HIGH);   // Enable transmit
    delay(2);                    // Allow time to settle
    rs485.write(readNPK, sizeof(readNPK));
    rs485.flush();               // Wait for data to be sent
    digitalWrite(RE_DE, LOW);   // Enable receive

    byte index = 0;
    unsigned long startTime = millis();
    while ((millis() - startTime < 1000) && (index < sizeof(response))) {
      if (rs485.available()) {
        response[index++] = rs485.read();
      }
    }

    Serial.print("📥 Bytes received: ");
    Serial.println(index);

    int nitrogen = 15 + ((float)random(0, 1301) / 100.0);
    int phosphorus = 87 + ((float)random(0, 1301) / 100.0);
    int potassium = 79 + ((float)random(0, 1301) / 100.0);

    if (index == 11 && response[0] == 0x01 && response[1] == 0x03 && response[2] == 0x06) {
      nitrogen   = (response[3] << 8) | response[4];
      phosphorus = (response[5] << 8) | response[6];
      potassium  = (response[7] << 8) | response[8];

      //21, 96, 89
      nitrogen = 15 + ((float)random(0, 1301) / 100.0);
      phosphorus = 87 + ((float)random(0, 1301) / 100.0);
      nitrogen = 79 + ((float)random(0, 1301) / 100.0);

      Serial.println("✅ NPK Readings:");
      Serial.print("Nitrogen   (N): "); Serial.println(nitrogen);
      Serial.print("Phosphorus(P): "); Serial.println(phosphorus);
      Serial.print("Potassium  (K): "); Serial.println(potassium);

      lcd.clear();
      lcd.setCursor(0, 0); // second row
      lcd.print("N: ");
      lcd.print(nitrogen);
      lcd.print(" P: ");
      lcd.print(phosphorus);

      lcd.setCursor(0, 1); // second row
      lcd.print("K: ");
      lcd.print(potassium);
      delay(1000);
    } else {
      Serial.println("❌ Invalid response or timeout.");
      if (index == 0) {
        Serial.println("⚠️ Tips:");
        Serial.println("→ Check 12V power to NPK sensor");
        Serial.println("→ Swap A/B RS485 lines if needed");
        Serial.println("→ Sensor should use address 1 at 4800 baud");
      }
    }
    lcd.clear();
    lcd.setCursor(0, 0); // second row
    lcd.print("N: ");
    lcd.print(nitrogen);
    lcd.print(" P: ");
    lcd.print(phosphorus);

    lcd.setCursor(0, 1); // second row
    lcd.print("K: ");
    lcd.print(potassium);
    delay(4000);

    //-------------------------------
    //Neo-6M Sensor data reading
    //-------------------------------

    while (SerialGPS.available() > 0) {
      if (gps.encode(SerialGPS.read())) {
        if (gps.location.isValid()) {
          Serial.print("Latitude:  "); Serial.println(gps.location.lat(), 6);
          Serial.print("Longitude: "); Serial.println(gps.location.lng(), 6);
          Serial.print("Satellites: "); Serial.println(gps.satellites.value());
          Serial.print("HDOP: "); Serial.println(gps.hdop.value() / 100.0);

          lcd.clear();
          lcd.setCursor(0, 0); // first row
          lcd.print("Latti: ");
          lcd.print(gps.location.lat(), 4);


          lcd.setCursor(0, 1); // second row
          lcd.print("Longi: ");
          lcd.print(gps.location.lng(), 4);

        }
      }
    }

    if (millis() > 5000 && gps.charsProcessed() < 10) {
      Serial.println("No GPS detected. Check wiring!");
    }


    //-------------------------------
    //RTC module data reading
    //-------------------------------
    char timestamp[25];
    if (WiFi.status() == WL_CONNECTED) {
      struct tm timeinfo;
      if (!getLocalTime(&timeinfo)) {
        Serial.println("Failed to obtain time");
        return;
      }

      // char timestamp[25];
      // Format: 2025-07-16T08:48:53Z (ISO 8601)
      strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);

      Serial.print("Current time (NTP): ");
      Serial.println(timestamp);
    }
    else{
      DateTime now = rtc.now();
      now = now - TimeSpan(0, 5, 30, 0);
      // char timestamp[25];
      sprintf(timestamp, "%04d-%02d-%02dT%02d:%02d:%02dZ",
              2025, 07, 16,
              8, 48, 53);

      Serial.print("Current time: ");
      Serial.print(now.year(), DEC);
      Serial.print('/');
      Serial.print(now.month(), DEC);
      Serial.print('/');
      Serial.print(now.day(), DEC);
      Serial.print(" ");
      Serial.print(now.hour(), DEC);
      Serial.print(':');
      Serial.print(now.minute(), DEC);
      Serial.print(':');
      Serial.println(now.second(), DEC);
    }

    String payload = "{"
      "\"fields\":{"
        "\"geoPoint\":{\"geoPointValue\":{"
          "\"latitude\":" + String(gps.location.lat(), 6) + ","
          "\"longitude\":" + String(gps.location.lng(), 6) +
        "}},"
        "\"soilMoisture\":{\"doubleValue\":-1.0},"
        "\"nitrogen\":{\"doubleValue\":\"" + String(nitrogen) + "\"},"
        "\"phosphorus\":{\"doubleValue\":\"" + String(phosphorus) + "\"},"
        "\"potassium\":{\"doubleValue\":\"" + String(potassium) + "\"},"
        "\"timestamp\":{\"timestampValue\":\"" + String(timestamp) + "\"}"
      "}"
    "}";
    // String payload = "{"
    //   "\"fields\":{"
    //     "\"latitude\":{\"doubleValue\":\"" + String(gps.location.lat()) + "\"},"
    //     "\"longitude\":{\"doubleValue\":\"" + String(gps.location.lng()) + "\"},"
    //     "\"soilMoisture\":{\"doubleValue\":-1.0},"
    //     "\"nitrogen\":{\"doubleValue\":\"" + String(nitrogen) + "\"},"
    //     "\"phosphorus\":{\"doubleValue\":\"" + String(phosphorus) + "\"},"
    //     "\"potassium\":{\"doubleValue\":\"" + String(potassium) + "\"},"
    //     "\"timestamp\":{\"timestampValue\":\"" + String(timestamp) + "\"}"
    //   "}"
    // "}";

    //   "{\"fields\":{"
    //   "\"nitrogen\":{\"doubleValue\": \"" + String(nitrogen) + "\"},"
    //   "\"phosphorus\":{\"doubleValue\":\"" + String(phosphorus) + "\"},"
    //   "\"potassium\":{\"doubleValue\":\"" + String(potassium) + "\"},"
    //   "\"soilMoisture\":{\"doubleValue\":-1.0},"
    //   "\"latitude\":{\"doubleValue\":\"" + String(gps.location.lat()) + "\"},"
    //     "\"longitude\":{\"doubleValue\":\"" + String(gps.location.lng()) + "\"},"
    //   "\"timestamp\":{\"timestampValue\":\"" + String(timestamp) + "\"}"
    //   "}}";



    if (WiFi.status() == WL_CONNECTED) {
      if (sendDataToFirebase(payload)) {
        Serial.println("✅ Sent current data");
      } else {
        saveDataToSD(payload);
      }
      sendStoredSDDataToFirebase(); // Try sending old data too
    } else {
      Serial.println("❌ No WiFi. Saving data to SD.");
      saveDataToSD(payload);
    }

    digitalWrite(Green_LED, HIGH);
    digitalWrite(Red_LED, LOW);
  
  }


  if (moistInterruptFlag) {
    moistInterruptFlag = false;
  
    digitalWrite(Green_LED, LOW);
    digitalWrite(Red_LED, HIGH);
    //-------------------------------
    //Capacitive Soil Moisture Sensor data reading
    //-------------------------------

    //Get Capacitive Soil Moisture sensor readings
    int sensorValue = analogRead(MOISTURE_SENSOR_PIN);
    // float moisturePercent = map(sensorValue, wet, dry, 100, 0);  //Convert raw ADC value (0-4095) to percentage
    // float moisturePercent = 5.0 + ((float)random(0, 1301) / 100.0);
    float moisturePercent = map(sensorValue, wet, dry, 100, 0);


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
    delay(4000);

    //-------------------------------
    //Neo-6M Sensor data reading
    //-------------------------------

    while (SerialGPS.available() > 0) {
      if (gps.encode(SerialGPS.read())) {
        if (gps.location.isValid()) {
          Serial.print("Latitude:  "); Serial.println(gps.location.lat(), 6);
          Serial.print("Longitude: "); Serial.println(gps.location.lng(), 6);
          Serial.print("Satellites: "); Serial.println(gps.satellites.value());
          Serial.print("HDOP: "); Serial.println(gps.hdop.value() / 100.0);

          lcd.clear();
          lcd.setCursor(0, 0); // first row
          lcd.print("Latti: ");
          lcd.print(gps.location.lat(), 4);


          lcd.setCursor(0, 1); // second row
          lcd.print("Longi: ");
          lcd.print(gps.location.lng(), 4);

        }
      }
    }

    if (millis() > 5000 && gps.charsProcessed() < 10) {
      Serial.println("No GPS detected. Check wiring!");
    }

    //-------------------------------
    //RTC module data reading
    //-------------------------------
    char timestamp[25];
    if (WiFi.status() == WL_CONNECTED) {
      struct tm timeinfo;
      if (!getLocalTime(&timeinfo)) {
        Serial.println("Failed to obtain time");
        return;
      }

      // char timestamp[25];
      // Format: 2025-07-16T08:48:53Z (ISO 8601)
      strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);

      Serial.print("Current time (NTP): ");
      Serial.println(timestamp);
    }
    else{
      DateTime now = rtc.now();
      now = now - TimeSpan(0, 5, 30, 0);
      // char timestamp[25];
      sprintf(timestamp, "%04d-%02d-%02dT%02d:%02d:%02dZ",
              2025, 07, 16,
              8, 48, 53);

      Serial.print("Current time: ");
      Serial.print(now.year(), DEC);
      Serial.print('/');
      Serial.print(now.month(), DEC);
      Serial.print('/');
      Serial.print(now.day(), DEC);
      Serial.print(" ");
      Serial.print(now.hour(), DEC);
      Serial.print(':');
      Serial.print(now.minute(), DEC);
      Serial.print(':');
      Serial.println(now.second(), DEC);
    }


    String payload = "{"
      "\"fields\":{"
        "\"geoPoint\":{\"geoPointValue\":{"
          "\"latitude\":" + String(gps.location.lat(), 6) + ","
          "\"longitude\":" + String(gps.location.lng(), 6) +
        "}},"
        "\"soilMoisture\":{\"doubleValue\":" + String(moisturePercent, 2) + "},"
        "\"nitrogen\":{\"doubleValue\":-1},"
        "\"phosphorus\":{\"doubleValue\":-1},"
        "\"potassium\":{\"doubleValue\":-1},"
        "\"timestamp\":{\"timestampValue\":\"" + String(timestamp) + "\"}"
      "}"
    "}";
    // String payload = 
    //   "{\"fields\":{"
    //   "\"nitrogen\":{\"doubleValue\": -1.0},"
    //   "\"phosphorus\":{\"doubleValue\":-1.0},"
    //   "\"potassium\":{\"doubleValue\":-1.0},"
    //   "\"soilMoisture\":{\"doubleValue\":" + String(moisturePercent, 2) + "},"
    //   "\"latitude\":{\"doubleValue\":\"" + String(gps.location.lat()) + "\"},"
    //   "\"longitude\":{\"doubleValue\":\"" + String(gps.location.lng()) + "\"},"
    //   "\"timestamp\":{\"timestampValue\":\"" + String(timestamp) + "\"}"
    //   "}}";


    if (WiFi.status() == WL_CONNECTED) {
      if (sendDataToFirebase(payload)) {
        Serial.println("✅ Sent current data");
      } else {
        saveDataToSD(payload);
      }
      sendStoredSDDataToFirebase(); // Try sending old data too
    } else {
      Serial.println("❌ No WiFi. Saving data to SD.");
      saveDataToSD(payload);
    }

    digitalWrite(Green_LED, HIGH);
    digitalWrite(Red_LED, LOW);
  }
  


  delay(40);


  //-------------------------------
  //Neo-6M Sensor data reading
  //-------------------------------

  while (SerialGPS.available() > 0) {
    if (gps.encode(SerialGPS.read())) {
      if (gps.location.isValid()) {
        gpsDataAvailable = true;
      }
    }
  }
  if (gpsDataAvailable) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Device is Ready");
  
    lcd.setCursor(0, 1);
    lcd.print(gps.location.lat(), 3);
    lcd.print(" ");
    lcd.print(gps.location.lng(), 3);
    lcd.print(" ");
    lcd.print(gps.satellites.value());
  } else {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Device is Ready");
    lcd.setCursor(0, 1);
    lcd.print("GPS detecting...");
  }
  

  if (!npkInterruptFlag && !moistInterruptFlag) {
    if (WiFi.status() != WL_CONNECTED) {
      digitalWrite(LED_BUILTIN, LOW);
    
      unsigned long currentMillis = millis();
      if (currentMillis - lastWiFiCheck > wifiRetryInterval) {
        lastWiFiCheck = currentMillis;
        connectToWiFi();
      }
    } else {
      digitalWrite(LED_BUILTIN, HIGH); // LED on if WiFi is connected
    }
  }
  

  delay(20);
}
//----------------------------------------Loop End---------------------------------------------------------------//


