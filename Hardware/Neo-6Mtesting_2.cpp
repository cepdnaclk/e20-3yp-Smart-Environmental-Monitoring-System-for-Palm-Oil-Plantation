#include <Arduino.h>
#include <WiFiMulti.h>
#include <TinyGPS++.h>
#include <HardwareSerial.h>
#include <LiquidCrystal_I2C.h>


#define LED_BUILTIN 2
#define WIFI_SSID "Dialog 4G"
#define WIFI_PASSWORD "J63E5AH8Q2B"

//static const int RXPin = 16, TXPin = 17; //ESP32 UART pins
//static const uint32_t GPSBaud = 9600; //GPS Baud rate

//Wifi instance
WiFiMulti wifiMulti;

//GPS instance
TinyGPSPlus gps;
HardwareSerial gpsSerial(2); //Use UART2

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);


void setup() {
  // put your setup code here, to run once:
  Serial.begin(921600);

  //Initialize GPS
  gpsSerial.begin(9600, SERIAL_8N1, 16, 17);
  
  Serial.println("NEO-6M Sensor Initialized!");
  
  pinMode(LED_BUILTIN, OUTPUT);
  
  // Initialize I2C and LCD
  lcd.init();  // or lcd.begin() depending on the library version
  lcd.backlight();  // Turn on the backlight

  // Display text on the LCD
  lcd.setCursor(0, 0);  // Column 0, Row 0
  lcd.print("Hello, ESP32!");
  
  lcd.setCursor(0, 1);  // Column 0, Row 1
  lcd.print("LCD Working :)");
}

void loop(){
  // put your main code here, to run repeatedly:

  float Lati = 0.0;
  float Longi = 0.0;

  while (true) {
    gps.encode(gpsSerial.read());

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

    // if (gps.location.isUpdated()) {
    //   Serial.print("Latitude: ");
    //   Serial.print(gps.location.lat(), 6);
    //   Serial.print(", Longitude: ");
    //   Serial.println(gps.location.lng(), 6);
    // }

    // if (gps.date.isUpdated()) {
    //   Serial.print("Date: ");
    //   Serial.print(gps.date.day());
    //   Serial.print("/");
    //   Serial.print(gps.date.month());
    //   Serial.print("/");
    //   Serial.println(gps.date.year());
    // }

    // if (gps.time.isUpdated()) {
    //   Serial.print("Time: ");
    //   Serial.print(gps.time.hour());
    //   Serial.print(":");
    //   Serial.print(gps.time.minute());
    //   Serial.print(":");
    //   Serial.println(gps.time.second());
    // }

    Serial.println("----------------------");

    //Display data on LCD
    lcd.clear();
    lcd.setCursor(0, 0); // first row
    lcd.print("Lati: ");
    lcd.print(Lati, 6);

    lcd.setCursor(0, 1); // second row
    lcd.print("Longi: ");
    lcd.print(Longi, 6);

    digitalWrite(LED_BUILTIN, HIGH);
    delay(1000);
    digitalWrite(LED_BUILTIN, LOW);
    delay(1000);
  }

}
