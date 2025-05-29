#include <Arduino.h>
#include <TinyGPS++.h>
#include <LiquidCrystal_I2C.h>

HardwareSerial SerialGPS(2);  // UART2: RX=GPIO16, TX=GPIO17
TinyGPSPlus gps;

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  Serial.begin(9600);          // Debug console
  SerialGPS.begin(9600);       // Neo-6M default baud rate

  Wire.begin(21, 22); // SDA, SCL

  // Initialize I2C and LCD
  lcd.init();  // or lcd.begin() depending on the library version
  lcd.backlight();  // Turn on the backlight

  // Display text on the LCD
  lcd.setCursor(0, 0);  // Column 0, Row 0
  lcd.print("Hello, ESP32!");
  
  lcd.setCursor(0, 1);  // Column 0, Row 1
  lcd.print("LCD Working :)");
}

void loop() {
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
    while (true);  // Freeze if no GPS data
  }
}