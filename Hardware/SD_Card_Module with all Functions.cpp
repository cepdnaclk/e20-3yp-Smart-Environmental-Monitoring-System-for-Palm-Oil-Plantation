#include <Arduino.h>
#include <SPI.h>
#include <SD.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <time.h>
#include <HTTPClient.h>

#define SD_CS 5  // Chip select pin

#define LED_BUILTIN 2
#define Yello_LED 33
const int myswitch = 4;
const int dataswitch = 27;

//Wifi credentials
#define WiFi_1_SSID "Dialog 4G"
#define PASSWORD1 "J63E5AH8Q2B"
#define WiFi_2_SSID "Galaxy A32 New"
#define PASSWORD2 "ishan011"
#define WiFi_3_SSID "PeraComStudent"
#define PASSWORD3 "abcd1234"
#define WiFi_4_SSID "PeraComStaff"
#define PASSWORD4 "pera1234"

//Wifi instance
WiFiMulti wifiMulti;
bool wifiConnected = false;
bool lastSwitchState = LOW;
bool lastdataState = LOW;

//Firebase project credentials
const char* firebaseProjectId = "environment-monitoring-s-d169b";
const char* apiKey = "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs";
const char* collection = "testingSD"; // Firestore collection name


void setup() {
  Serial.begin(115200);
  SPI.begin(18, 19, 23, SD_CS); // SCK, MISO, MOSI, CS

  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(Yello_LED, OUTPUT);
  pinMode(myswitch, INPUT);
  pinMode(dataswitch, INPUT);

  //Connect to WiFi 
  wifiMulti.addAP(WiFi_1_SSID, PASSWORD1);
  wifiMulti.addAP(WiFi_2_SSID, PASSWORD2);
  wifiMulti.addAP(WiFi_3_SSID, PASSWORD3);
  wifiMulti.addAP(WiFi_4_SSID, PASSWORD4);
  // Initial Wi-Fi status
  wifiConnected = false;
  


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
}


String generateSensorDataJson() {

  Serial.println("Start generating payload.");

  //Get current time
  configTime(0, 0, "pool.ntp.org", "time.nist.gov");
  delay(1000);

  struct tm timeinfo;
  char timestamp[30];

  if (!getLocalTime(&timeinfo)) {
    Serial.println("Failed to obtain time");
  } else {
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);
    Serial.println(timestamp);
  }

  String jsonPayload = 
    "{\"fields\":{"
    "\"temperature\":{\"doubleValue\":27.3},"
    "\"humidity\":{\"doubleValue\":65.6},"
    "\"soilMoisture\":{\"doubleValue\":7.2},"
    "\"latitude\":{\"doubleValue\":7.2538},"
    "\"longitude\":{\"doubleValue\":80.5916},"
    "\"timestamp\":{\"timestampValue\":\"" + String(timestamp) + "\"}"
    "}}";

  return jsonPayload;
}

void saveDataToSD(String jsonPayload) {

  Serial.println("Start Saving data to SD");
  File file = SD.open("/unsent_data.txt", FILE_APPEND);
  if (file) {
    file.println(jsonPayload);
    file.flush();
    file.close();
    Serial.println("Saved to SD card.");
  } else {
    Serial.println("Failed to write to SD card.");
  }
}


bool sendDataToFirebase(String jsonPayload) {

  Serial.println("Start sending data to Firebase");
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


void sendStoredSDDataToFirebase() {
  Serial.println("Start sending stored data to Firebase...");

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
    } else {
      Serial.println("✅ Sent from SD → Firebase");
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


void connectToWiFi() {
  Serial.println("🔌 Connecting to WiFi...");
  wifiMulti.run();  // Initiate connection attempt
  
  wifiConnected = (WiFi.status() == WL_CONNECTED);
  if (wifiConnected) {
    Serial.println("✅ Connected!");
    sendStoredSDDataToFirebase();
  } else {
    Serial.println("❌ Failed to connect.");
  }
}

void disconnectWiFi() {
  Serial.println("📴 Disconnecting WiFi...");
  WiFi.disconnect(true);
  wifiConnected = false;
  Serial.println("Disconnected!");
}




// void uploadToCloud(){
//   //Upload data to Firebase Firestore
//   if (WiFi.status() == WL_CONNECTED) {
//     HTTPClient http;
    
//     String url = "https://firestore.googleapis.com/v1/projects/" + 
//                   String(firebaseProjectId) + 
//                   "/databases/(default)/documents/" + 
//                   String(collection) + "?key=" + 
//                   String(apiKey);

//     http.begin(url);
//     http.addHeader("Content-Type", "application/json");

    //Get current time
    // configTime(0, 0, "pool.ntp.org", "time.nist.gov");
    // delay(1000);

    // struct tm timeinfo;
    // char timestamp[30];

    // if (!getLocalTime(&timeinfo)) {
    //   Serial.println("Failed to obtain time");
    // } else {
    //   strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);
    //   Serial.println(timestamp);
    // }


//     //Sample sensor data (adjust this with real sensor readings)
//     String jsonPayload = R"(
//       {
//         "fields": {
//           "temperature": {"doubleValue": 27.3},
//           "humidity": {"doubleValue": 65.6},
//           "soilMoisture": {"doubleValue": 7.2},
//           "latitude": {"doubleValue": 7.2538},
//           "longitude": {"doubleValue": 80.5916},
//           "timestamp": {"timestampValue": ")" + String(timestamp) + R"("}
//         }
//       }
//     )";

//     int httpResponseCode = http.POST(jsonPayload);
    
//     if (httpResponseCode > 0) {
//       Serial.print("Data sent! Response code: ");
//       Serial.println(httpResponseCode);
//       Serial.println(http.getString());
//     } else {
//       Serial.print("Error sending data: ");
//       Serial.println(httpResponseCode);
//     }
    
//     http.end();
//   }
//   else{
//     Serial.print("Wifi not connected.");
//   }
// }


void loop() {
  
  bool currentSwitchState = digitalRead(myswitch);
  bool currentdataState = digitalRead(dataswitch);

  // Detect rising edge
  if (currentSwitchState == HIGH && lastSwitchState == LOW) {
    if (wifiConnected) {
      disconnectWiFi();
    } else {
      connectToWiFi();
    }
  }

  if(currentdataState == HIGH && lastdataState == LOW){
    String payload = generateSensorDataJson();

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
  
    delay(4000);
  }

  lastSwitchState = currentSwitchState;
  lastdataState = currentdataState;

  // Always reflect actual status
  digitalWrite(LED_BUILTIN, WiFi.status() == WL_CONNECTED);
  // uploadToCloud();

  delay(3000);  // Debounce
}



// append a line to /data.csv on SD
// void logToSD(const String &line) {
//   File f = SD.open("/data.csv", FILE_WRITE);
//   if (f) {
//     f.println(line);
//     f.close();
//     Serial.println("Logged to SD: " + line);
//   }
// }

// upload one JSON record to Firestore under collection "readings"
// bool uploadRecord(const String &ts, float hum, float temp, double lat, double lon) {
  // String path = String("/readings/") + ts;     // document ID = timestamp
  // FirebaseJson j;
  // j.set("timestamp", ts);
  // j.set("humidity", hum);
  // j.set("temperature", temp);
  // j.set("latitude", lat);
  // j.set("longitude", lon);
  // return Firebase.Firestore.createDocument(&fbdo, PROJECT_ID, "(default)", "readings", ts.c_str(), j.raw(), "timestamp");
// }

// read all lines, upload, then remove data.csv
// void flushSDToCloud() {
//   if (!SD.exists("/data.csv")) return;

//   File f = SD.open("/data.csv");
//   if (!f) return;

//   while (f.available()) {
//     String line = f.readStringUntil('\n');
//     line.trim();
//     if (line.length() == 0) continue;

//     // CSV: timestamp,humidity,temperature,lat,lon
//     String parts[5];
//     int partIndex = 0;
//     int startIdx = 0;

//     while (partIndex < 5) {
//       int comma = line.indexOf(',', startIdx);
//       if (comma == -1) comma = line.length();
//       parts[partIndex++] = line.substring(startIdx, comma);
//       startIdx = comma + 1;
//     }
    
//     uploadRecord(parts[0], parts[1].toFloat(), parts[2].toFloat(),
//                   parts[3].toDouble(), parts[4].toDouble());
    
//   }
//   f.close();
//   SD.remove("/data.csv");
//   Serial.println("Flushed SD → Firestore");
// }