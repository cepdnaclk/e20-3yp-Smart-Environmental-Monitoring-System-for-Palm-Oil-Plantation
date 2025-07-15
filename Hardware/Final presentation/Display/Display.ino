#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Use the I2C address 0x27 for 16x2 or 20x4 LCDs
LiquidCrystal_I2C lcd(0x27, 16, 2); // 16 columns, 2 rows

void setup() {
  lcd.init();              // Initialize the LCD
  lcd.backlight();         // Turn on the backlight
  lcd.setCursor(0, 0);     
  lcd.print("Starting...");
}

void loop() {
  // your logic here
}
