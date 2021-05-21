#include <Arduino.h>

// for Serial Bluetooth
#include "BluetoothSerial.h" 

// check if Bluetooth is properly enabled.
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

// Object for bluetooth
BluetoothSerial ESP_BT;

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
}