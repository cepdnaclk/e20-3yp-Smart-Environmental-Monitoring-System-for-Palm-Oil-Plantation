#include <Wire.h>
#include "RTClib.h"

RTC_DS3231 rtc;

void setup() {
  Serial.begin(115200);
  Wire.begin(21, 22); // SDA, SCL

  if (!rtc.begin()) {
    Serial.println("Couldn't find RTC");
    while (1);
  }

  if (rtc.lostPower()) {
    Serial.println("RTC lost power, setting time!");
    // Set time only once
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
    // OR set manually like this:
    // rtc.adjust(DateTime(2025, 5, 20, 14, 30, 0)); // YYYY, MM, DD, HH, MM, SS
  }
}

void loop() {
  DateTime now = rtc.now();

  Serial.print("Current Date & Time: ");
  Serial.print(now.year(), DEC);
  Serial.print('/');
  Serial.print(now.month(), DEC);
  Serial.print('/');
  Serial.print(now.day(), DEC);
  Serial.print(" ");
  Serial.print(now.hour(), DEC);
  Serial.print(':');
  Serial.print(now.minute(), DEC);
  Serial.print(':');
  Serial.println(now.second(), DEC);

  delay(10000);
}
