// ESP8266 Tipping Bucket Gauge with Hall Sensor
const int sensorPin = D2;  // Hall sensor connected to GPIO4 (D2 on NodeMCU)
volatile int tipCount = 0; // Count of bucket tips

// Debounce parameters
unsigned long lastTipTime = 0;
const unsigned long debounceDelay = 500; // milliseconds, adjust if needed

void IRAM_ATTR detectTip() {
  unsigned long currentTime = millis();
  // Debounce: ignore multiple triggers within debounceDelay milliseconds
  if ((currentTime - lastTipTime) > debounceDelay) {
    tipCount++;
    lastTipTime = currentTime;
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(sensorPin, INPUT_PULLUP); // or INPUT depending on your sensor
  attachInterrupt(digitalPinToInterrupt(sensorPin), detectTip, FALLING);
  Serial.println("Tipping bucket gauge ready.");
}

void loop() {
  static int lastPrintedCount = 0;

  if (lastPrintedCount != tipCount) {
    lastPrintedCount = tipCount;
    Serial.print("Bucket tips detected: ");
    Serial.println(tipCount);
  }

  delay(100); 

}
