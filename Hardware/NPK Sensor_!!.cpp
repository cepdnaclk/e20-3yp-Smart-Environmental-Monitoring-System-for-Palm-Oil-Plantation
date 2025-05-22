#include <HardwareSerial.h>

HardwareSerial modbusSerial(2); // UART2

uint8_t requestFrame[] = {0x01, 0x03, 0x00, 0x00, 0x00, 0x03, 0x05, 0xCB};

void setup() {
  Serial.begin(115200);
  
  delay(2000);
  Serial.println("NPK Sensor Test");
}

void loop() {
  modbusSerial.flush(); // Clear UART buffer
  while (modbusSerial.amodbusSerial.begin(9600, SERIAL_8N1, 16, 17); // RX=16, TX=17vailable()) modbusSerial.read(); // Clear any residual data

  modbusSerial.write(requestFrame, sizeof(requestFrame));
  Serial.println("Sent request...");

  delay(300); // Wait for sensor response

  if (modbusSerial.available()) {
    Serial.print("Response: ");
    while (modbusSerial.available()) {
      uint8_t b = modbusSerial.read();
      Serial.printf("%02X ", b);
    }
    Serial.println();
  } else {
    Serial.println("No response / Modbus timeout.");
  }

  // uint8_t response[11]; // Expected response length
  // int index = 0;

  // while (modbusSerial.available() && index < sizeof(response)) {
  //   response[index++] = modbusSerial.read();
  // }

  // if (index == 11 && response[1] == 0x03) {
  //   // Extract NPK values
  //   uint16_t nitrogen   = (response[3] << 8) | response[4];
  //   uint16_t phosphorus = (response[5] << 8) | response[6];
  //   uint16_t potassium  = (response[7] << 8) | response[8];

  //   Serial.println("Received NPK values:");
  //   Serial.print("Nitrogen (N): "); Serial.println(nitrogen);
  //   Serial.print("Phosphorus (P): "); Serial.println(phosphorus);
  //   Serial.print("Potassium (K): "); Serial.println(potassium);
  // } else {
  //   Serial.println("No valid response or Modbus timeout.");
  // }

  delay(3000);
}
