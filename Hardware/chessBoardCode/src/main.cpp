#include <Arduino.h>

// Define Pin Numbers for the Esp32 Dev Board
// connections to shift Registers of LedPanel
int dataPin = 2;
int latchPin = 4;
int clockPin = 5;

// Arrays to hold values to be send to shift registers
int anode_values[8];
int red_values[8];
int green_values[8];
int blue_values[8];

// Final array to send the shift registers with correct order
int register_values[32];

// Details of the movement to be displayed (should recieve via bluetooth)
String moveNotation, moveEnd, moveStart;

// Details should extract from the movement details
int startRow, startCol;
int endRow, endCol;

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
}