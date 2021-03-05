#include <Arduino.h>

// Define Pin Numbers for the Esp32 Dev Board
// connections to shift Registers of LedPanel
int dataPin = 2;    // Pin connected to SER
int latchPin = 4;   // Pin connected to RCLK
int clockPin = 5;   // Pin connected to SRCLK

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

// variable for multiplexing
int col_position = 0;

// cells to be lightup in the matrix
// 1 - start square (Red), 2 - end square (green), 3 - Path of the movement (blue) 
int cells[8][8] = {
  {0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0}
};

// set of functions need
void clearCells();
void displayPanel();
void clearRegisters();
void writeRegisters();
void setRegisterPin(char regType, int index, boolean value);
void decodeMove(String moveNotation, String moveEnd, String moveStart);

void setup() {
  // LedPanel
  pinMode(dataPin, OUTPUT);
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);

  // Reset all the register pins
  clearRegisters();
  writeRegisters();

  // dummy data to check functionality
  moveNotation = "Nf3";  
  moveEnd = "f3"; 
  moveStart = "g1" ;
  decodeMove(moveNotation, moveEnd, moveStart);
}

void loop() {
  displayPanel();
}

// function that set all the values of cell 2d array to zero 
void clearCells(){
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < 8; j++){
      cells[i][j] = 0;
    }
  }
}

// function that clear all register values in order to off the ledPanel 
void clearRegisters(){
  for(int i = 0; i < 8; i++){
    // Since the led Panel is common anode: 
    // in order to off a led - anode should be LOW and cathodes shoul be HIGH  
    anode_values[i] = LOW;
    red_values[i] = HIGH;
    green_values[i] = HIGH;
    blue_values[i] = HIGH;
  }
}

// function to assign HIGH/LOW to required register index
void setRegisterPin(char regType, int index, boolean value){
  if (regType == 'R'){
    red_values[index] = value;
  }else if (regType == 'G'){
    green_values[index] = value;
  }else if(regType == 'B'){
    blue_values[index] =value;
  }else if(regType == 'A'){
    anode_values[index] = value;
  }
}

void writeRegisters(){
  // Store the bit values by order to send to the shift registers
  for (int i = 0; i < 32; i++){
    if (i < 8){
      register_values[i] = blue_values[7 - i];
    }else if (i < 16){
      register_values[i] = green_values[7 - (i - 8)];
    }else if (i < 24){
      register_values[i] = red_values[7 - (i - 16)];
    }else{
      register_values[i] = anode_values[7 - (i - 24)];
    }
  }

  // Set latchPin to LOW inorder to start data writing to shift registers
  digitalWrite(latchPin, LOW);

  // write the register_values to datapin
  for(int i = 0; i < 32; i++){
    // Procedure : set clock to low -> write a bit -> set clock to high
    digitalWrite(clockPin, LOW);
    digitalWrite(dataPin, register_values[i]);
    digitalWrite(clockPin, HIGH);  
  }

  // set the latchPin to HIGH after sending to registers
  digitalWrite(latchPin, HIGH);
}

// function to display movement details on the matrix
void displayPanel(){
  // clear all LEDs
  clearRegisters();

  // display starting point of the movement in Red
  setRegisterPin('A', startRow, HIGH);
  setRegisterPin('R', startCol, LOW);
  setRegisterPin('G', startCol, HIGH);
  setRegisterPin('B', startCol, HIGH);

  writeRegisters();
  clearRegisters();

  // display end point of the movement in Green
  setRegisterPin('A', endRow, HIGH);
  setRegisterPin('R', endCol, HIGH);
  setRegisterPin('G', endCol, LOW);
  setRegisterPin('B', endCol, HIGH);

  writeRegisters();
  clearRegisters();

  // display path in blue
  for (int row = 0; row < 8; row++){
    if(cells[row][col_position] == 3){
      // display end point of the movement in Blue
      setRegisterPin('A', endRow, HIGH);
      setRegisterPin('R', endCol, HIGH);
      setRegisterPin('G', endCol, HIGH);
      setRegisterPin('B', endCol, LOW);
    }
  }
  writeRegisters();
  col_position++;
  if(col_position == 8){
    col_position = 0;
  }
}

// function to decode the move Notations and store in cells[][]
void decodeMove(String moveNotation, String moveEnd, String moveStart){
  
  char boardCols[] = {'a', 'b', 'c','d', 'e', 'f', 'g', 'h'};

  // ----- Decoding the start and end squares -----
  for (int i = 0; i < 8; i++){
    // Set the start square in the cells[][]
    if(moveStart[0] == boardCols[i]){
      startRow = moveStart[1] - '0'- 1;
      startCol = i;
      cells[startRow][startCol] = 1;
    }

    // set the end square in the cells 2D array
    if(moveEnd[0] == boardCols[i]){
      endRow = moveEnd[1] - '0' - 1;
      endCol = i;
      cells[endRow][endCol] = 2;
    }
  }
}