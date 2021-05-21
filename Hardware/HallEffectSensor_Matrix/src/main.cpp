#include <Arduino.h>

// for Serial Bluetooth
#include "BluetoothSerial.h" 

// check if Bluetooth is properly enabled.
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

// Object for bluetooth
BluetoothSerial ESP_BT;

// color definitions
#define BLACK 0
#define RED 1
#define ORANGE 2
#define YELLOW 3
#define GREEN 4
#define CYAN 5
#define BLUE 6
#define VIOLET 7
#define MAGENTA 8
#define WHITE 128

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
}