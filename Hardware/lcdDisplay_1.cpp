#include <Arduino.h>
#include <WiFiMulti.h>
#include <DHT.h>
#include <LiquidCrystal_I2C.h>

#define LED_BUILTIN 2
#define WIFI_SSID "Dialog 4G"
#define WIFI_PASSWORD "J63E5AH8Q2B"

#define DHTPIN 26
#define DHTTYPE DHT22

#define SDA_PIN 21
#define SCL_PIN 22
//(Didn't use)

//Wifi instance
WiFiMulti wifiMulti;

//DHT sensor instance
DHT dht(DHTPIN, DHTTYPE);

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(921600);
  Serial.println("DHT22 Sensor Reading!");
  pinMode(LED_BUILTIN, OUTPUT);
  dht.begin();
  delay(2000);

  //Connect to WiFi 
  // wifiMulti.addAP(WIFI_SSID, WIFI_PASSWORD);
  // while(wifiMulti.run() != WL_CONNECTED){
  //   delay(100);
  // }
  // Serial.println("WiFi connected");


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
  // put your main code here, to run repeatedly:
  // delay(100);
  // digitalWrite(LED_BUILTIN, WiFi.status() == WL_CONNECTED); // LED on if wifi is connected
  //Serial.println("Hello, World loop!");

  float temp = dht.readTemperature();
  float humidity = dht.readHumidity();

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

  digitalWrite(LED_BUILTIN, HIGH);
  delay(4000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(4000);

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
}