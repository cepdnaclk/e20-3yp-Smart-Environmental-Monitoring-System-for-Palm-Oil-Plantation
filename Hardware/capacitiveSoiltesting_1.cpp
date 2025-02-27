#include <Arduino.h>
#include <LiquidCrystal_I2C.h>

#define LED_BUILTIN 2

#define MOISTURE_SENSOR_PIN 34

const int dry = 2750; // value for dry sensor
const int wet = 970; // value for wet sensor

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);


void setup() {
  // put your setup code here, to run once:
  Serial.begin(921600);

  
  Serial.println("Capacitive soil moisture Sensor Initialized!");
  
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(MOISTURE_SENSOR_PIN, INPUT);
  
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
  
  //Serial.println(analogRead(MOISTURE_SENSOR_PIN));

  int sensorValue = analogRead(MOISTURE_SENSOR_PIN);
    
  //Convert raw ADC value (0-4095) to percentage
  float moisturePercent = map(sensorValue, wet, dry, 100, 0);  

  Serial.print("Moisture Level: ");
  Serial.print(moisturePercent);
  Serial.println("%");

  digitalWrite(LED_BUILTIN, HIGH);
  delay(400);
  digitalWrite(LED_BUILTIN, LOW);
  delay(400);

  // Display data on LCD
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Moist: ");
  lcd.print(moisturePercent);
  lcd.print("%");

}
