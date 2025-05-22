#include <SoftwareSerial.h>

#define RE_DE 14      // D5
#define RX_PIN 13     // D7
#define TX_PIN 12     // D6

SoftwareSerial rs485(RX_PIN, TX_PIN);
const byte readNPK[] = {0x01, 0x03, 0x00, 0x1E, 0x00, 0x03, 0x65, 0xCD};
byte response[11];

void setup() {
  Serial.begin(9600);
  rs485.begin(4800);
  pinMode(RE_DE, OUTPUT);
  digitalWrite(RE_DE, LOW);
  Serial.println("SN-3002-TR-NPK-N01 Reader Ready");
}

void loop() {
  Serial.println("\nSending NPK request...");

  digitalWrite(RE_DE, HIGH);
  delay(2);
  rs485.write(readNPK, sizeof(readNPK));
  rs485.flush();
  digitalWrite(RE_DE, LOW);

  byte index = 0;
  unsigned long startTime = millis();
  while ((millis() - startTime < 1000) && (index < 11)) {
    if (rs485.available()) {
      response[index++] = rs485.read();
    }
  }

  Serial.print("Bytes received: ");
  Serial.println(index);

  if (index == 11 && response[0] == 0x01 && response[1] == 0x03 && response[2] == 0x06) {
    int nitrogen   = (response[3] << 8) | response[4];
    int phosphorus = (response[5] << 8) | response[6];
    int potassium  = (response[7] << 8) | response[8];

    Serial.println("✅ SN-3002 NPK Readings:");
    Serial.print("Nitrogen   (N): "); Serial.println(nitrogen);
    Serial.print("Phosphorus(P): "); Serial.println(phosphorus);
    Serial.print("Potassium  (K): "); Serial.println(potassium);
  } else {
    Serial.println("❌ Invalid response or timeout.");
    if (index == 0) {
      Serial.println("Tips:");
      Serial.println("→ Check 12V sensor power");
      Serial.println("→ Check A/B wiring (try swapping)");
      Serial.println("→ Ensure sensor uses address 1 at 4800 baud");
    }
  }

  delay(5000);
}
