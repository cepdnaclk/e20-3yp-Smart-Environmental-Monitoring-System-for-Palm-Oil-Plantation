#include <HardwareSerial.h>
#include <Arduino.h>
#include <LiquidCrystal_I2C.h>

#define RE_DE 32     // DE & RE control pin for MAX485 (D14)
#define RX_PIN 25    // UART2 RX (D25)
#define TX_PIN 26    // UART2 TX (D26)

HardwareSerial rs485(2);  // UART2

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);

const byte readNPK[] = {0x01, 0x03, 0x00, 0x1E, 0x00, 0x03, 0x65, 0xCD};
byte response[11];

void setup() {
  Serial.begin(115200);  // Serial monitor
  rs485.begin(4800, SERIAL_8N1, RX_PIN, TX_PIN);  // UART2 init with GPIO25,26

  pinMode(RE_DE, OUTPUT);
  digitalWrite(RE_DE, LOW);  // Start in receive mode

  Serial.println("✅ SN-3002-TR-NPK-N01 Reader Ready (ESP32 UART2 + MAX485)");

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

  if (index == 11 && response[0] == 0x01 && response[1] == 0x03 && response[2] == 0x06) {
    int nitrogen   = (response[3] << 8) | response[4];
    int phosphorus = (response[5] << 8) | response[6];
    int potassium  = (response[7] << 8) | response[8];

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

  } else {
    Serial.println("❌ Invalid response or timeout.");
    if (index == 0) {
      Serial.println("⚠️ Tips:");
      Serial.println("→ Check 12V power to NPK sensor");
      Serial.println("→ Swap A/B RS485 lines if needed");
      Serial.println("→ Sensor should use address 1 at 4800 baud");
    }
  }

  

  delay(5000);
}
