#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>


// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);

#define Red_LED 27
#define Green_LED 33
const int myswitch = 12;
const int dataswitch = 14;

bool lastSwitchState = LOW;
bool lastdataState = LOW;

void setup() {
  Serial.begin(115200);
  Wire.begin(21, 22);  // SDA, SCL for ESP32

  // Initialize I2C and LCD
  lcd.init();  // or lcd.begin() depending on the library version
  lcd.backlight();  // Turn on the backlight

  // Display text on the LCD
  lcd.setCursor(0, 0);  // Column 0, Row 0
  lcd.print("Hello, ESP32!");
  
  lcd.setCursor(0, 1);  // Column 0, Row 1
  lcd.print("LCD Working :)");

  pinMode(Red_LED, OUTPUT);
  pinMode(Green_LED, OUTPUT);
  pinMode(myswitch, INPUT);
  pinMode(dataswitch, INPUT);

}

void loop() {

  bool currentSwitchState = digitalRead(myswitch);
  bool currentdataState = digitalRead(dataswitch);

  // Detect rising edge
  if (currentSwitchState == HIGH && lastSwitchState == LOW) {
    digitalWrite(Red_LED, HIGH);
    digitalWrite(Green_LED, LOW);
  }

  if(currentdataState == HIGH && lastdataState == LOW){
    digitalWrite(Red_LED, LOW);
    digitalWrite(Green_LED, HIGH);
  }

  // Display data on LCD
  // lcd.clear();
  // lcd.setCursor(0, 0); // first row
  // lcd.print(now.year(), DEC);
  // lcd.print(", ");
  // lcd.print(now.month(), DEC);

  // lcd.setCursor(0, 1); // second row
  // lcd.print(now.day(), DEC);
  // lcd.print(", ");
  // lcd.print(now.hour(), DEC);

  delay(10);
}
