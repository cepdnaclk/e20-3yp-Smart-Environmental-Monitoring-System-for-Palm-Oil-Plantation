#include <Arduino.h>
#include <SPI.h>
#include <SD.h>

#define SD_CS 5  // Chip select pin

void setup() {
  Serial.begin(115200);
  SPI.begin(18, 19, 23, SD_CS); // SCK, MISO, MOSI, CS

  Serial.println("Initializing SD card...");

  if (!SD.begin(SD_CS)) {
    Serial.println("SD card initialization failed!");
    return;
  }
  Serial.println("SD card initialized.");

  // Write to file
  File file = SD.open("/test.txt", FILE_WRITE);
  if (file) {
    file.println("Hello from ESP32!");
    file.close();
    Serial.println("Data written to test.txt");
  } else {
    Serial.println("Failed to open file for writing.");
  }

  // Read from file
  file = SD.open("/test.txt");
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

// append a line to /data.csv on SD
void logToSD(const String &line) {
  File f = SD.open("/data.csv", FILE_WRITE);
  if (f) {
    f.println(line);
    f.close();
    Serial.println("Logged to SD: " + line);
  }
}

// read all lines, upload, then remove data.csv
void flushSDToCloud() {
  if (!SD.exists("/data.csv")) return;

  File f = SD.open("/data.csv");
  if (!f) return;

  while (f.available()) {
    String line = f.readStringUntil('\n');
    line.trim();
    if (line.length() == 0) continue;

    // CSV: timestamp,humidity,temperature,lat,lon
    String parts[5];
    int partIndex = 0;
    int startIdx = 0;

    while (partIndex < 5) {
      int comma = line.indexOf(',', startIdx);
      if (comma == -1) comma = line.length();
      parts[partIndex++] = line.substring(startIdx, comma);
      startIdx = comma + 1;
    }
    
    // uploadRecord(parts[0], parts[1].toFloat(), parts[2].toFloat(),
    //               parts[3].toDouble(), parts[4].toDouble());
    
  }
  f.close();
  SD.remove("/data.csv");
  Serial.println("Flushed SD → Firestore");
}

void loop() {
  // Do nothing
}
