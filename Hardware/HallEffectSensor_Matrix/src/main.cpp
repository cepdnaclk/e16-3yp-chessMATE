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
#define WHITE 128

// misc defines
#define RETRIEVE 0
#define STORE 1

// chess pieces and spaces definitions
#define BORDER 255
#define EMPTY 0
#define BLACK_PAWN 1
#define BLACK_KNIGHT 3
#define BLACK_BISHOP 4
#define BLACK_ROOK 5
#define BLACK_QUEEN 9
#define BLACK_KING 16
#define WHITE_PAWN 129
#define WHITE_KNIGHT 131
#define WHITE_BISHOP 132
#define WHITE_ROOK 133
#define WHITE_QUEEN 137
#define WHITE_KING 144

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
}