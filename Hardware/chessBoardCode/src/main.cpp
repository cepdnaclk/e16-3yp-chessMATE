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
  moveNotation = "Qg7";  
  moveEnd = "g7"; 
  moveStart = "d4" ;
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
      setRegisterPin('A', row, HIGH);
      setRegisterPin('R', col_position, HIGH);
      setRegisterPin('G', col_position, HIGH);
      setRegisterPin('B', col_position, LOW);
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

  // ------------ Set Path of the Movement -------------
  // 1. Pawn
  if (moveNotation.length() == 2){
    // additional square is going to add only if it the first move of the pawn
    if (abs(endRow - startRow) == 2){
      // white move
      if (endRow > startRow){
        cells[startRow+1][startCol] = 3;
      }
      // black move
      else{
        cells[startRow-1][startCol] = 3;
      }
    }
  }
  // 2. Knight
  else if((moveNotation.length() == 3) && (String(moveNotation[0]).equals("N"))){
    // knight moved up 
    if (endRow > startRow){
      cells[startRow+1][startCol] = 3;
    }
    // knight moved down
    else{
      cells[startRow-1][startCol] = 3;
    }
    // knight moved right
    if (endCol > startCol){
      cells[endRow][endCol-1] = 3;
    }
    // knight moved left 
    else{
      cells[endRow][endCol+1] = 3;
    }
  }
  // 3. Bishop 
  else if((moveNotation.length() == 3) && (String(moveNotation[0]).equals("B"))){
    // Bishop moved up
    if (endRow > startRow){
      // Bishop moved right
      if (endCol > startCol){
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow+i][startCol+i] = 3;
        }
      }
      // Bishop moved left
      else{
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow+i][startCol-i] = 3;
        }
      }
    }
    // Bishop moved down
    else{
      // Bishop moved right
      if (endCol > startCol){
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow-i][startCol+i] = 3;
        }
      }
      // Bishop moved left
      else{
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow-i][startCol-i] = 3;
        }
      }
    }
  }
  // 4. Rook
  else if((moveNotation.length() == 3) && (String(moveNotation[0]).equals("R"))){
    // Rook moved up
    if (endRow > startRow){
      for (int i = 1; i < (abs(endRow-startRow)); i++){
        cells[startRow + i][startCol] = 3;
      }
    }
    // Rook moved down
    else if (endRow < startRow){
      for (int i = 1; i < (abs(endRow-startRow)); i++){
        cells[startRow - i][startCol] = 3;
      }
    }
    // Rook moved right
    else if (endCol > startCol){
      for (int i = 1; i < (abs(endCol-startCol)); i++){
        cells[startRow][startCol+i] = 3;
      }
    }
    // Rook moved left
    else if (endCol < startCol){
      for (int i = 1; i < (abs(endCol-startCol)); i++){
        cells[startRow][startCol-i] = 3;
      }
    }
  }
  // 5. Queen
  else if((moveNotation.length() == 3) && (String(moveNotation[0]).equals("Q"))){
    // Queen moved up
    if (endRow > startRow){
      // and Queen moved right
      if (endCol > startCol){
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow+i][startCol+i] = 3;
        }
      }
      // and Queen moved left
      else if(endCol < startCol){
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow+i][startCol-i] = 3;
        }
      }
      // only up
      else{
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow+i][startCol] = 3;
        }
      }
    }
    // Queen moved down
    else if(endRow < startRow){
      // and Queen moved right
      if (endCol > startCol){
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow-i][startCol+i] = 3;
        }
      }
      // and Queen moved left
      else if(endCol < startCol){
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow-i][startCol-i] = 3;
        }
      }
      // only down
      else{
        for (int i = 1; i < (abs(endRow-startRow)); i++){
          cells[startRow-i][startCol] = 3;
        }
      }
    }
    // queen moved only horizontally
    else{
      // and Queen moved right
      if (endCol > startCol){
        for (int i = 1; i < (abs(endCol-startCol)); i++){
          cells[startRow][startCol+i] = 3;
        }
      }
      // and Queen moved left
      else if(endCol < startCol){
        for (int i = 1; i < (abs(endCol-startCol)); i++){
          cells[startRow][startCol-i] = 3;
        }
      }
    }
  }
  // King
  else if((moveNotation.length() == 3) && (String(moveNotation[0]).equals("K"))){
    // -> no path for kings normal movements
    // todo: Path exists only for castling
  }
}