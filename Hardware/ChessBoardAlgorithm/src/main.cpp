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

// initial piece positions
byte piecesVal[12][12] =  {{BORDER, BORDER, BORDER,     BORDER,       BORDER,       BORDER,      BORDER,     BORDER,       BORDER,       BORDER,     BORDER, BORDER},
                           {BORDER, BORDER, BORDER,     BORDER,       BORDER,       BORDER,      BORDER,     BORDER,       BORDER,       BORDER,     BORDER, BORDER},
                           {BORDER, BORDER, BLACK_ROOK, BLACK_KNIGHT, BLACK_BISHOP, BLACK_QUEEN, BLACK_KING, BLACK_BISHOP, BLACK_KNIGHT, BLACK_ROOK, BORDER, BORDER},
                           {BORDER, BORDER, BLACK_PAWN, BLACK_PAWN,   BLACK_PAWN,   BLACK_PAWN,  BLACK_PAWN, BLACK_PAWN,   BLACK_PAWN,   BLACK_PAWN, BORDER, BORDER},
                           {BORDER, BORDER, EMPTY,      EMPTY,        EMPTY,        EMPTY,       EMPTY,      EMPTY,        EMPTY,        EMPTY,      BORDER, BORDER},
                           {BORDER, BORDER, EMPTY,      EMPTY,        EMPTY,        EMPTY,       EMPTY,      EMPTY,        EMPTY,        EMPTY,      BORDER, BORDER},
                           {BORDER, BORDER, EMPTY,      EMPTY,        EMPTY,        EMPTY,       EMPTY,      EMPTY,        EMPTY,        EMPTY,      BORDER, BORDER},
                           {BORDER, BORDER, EMPTY,      EMPTY,        EMPTY,        EMPTY,       EMPTY,      EMPTY,        EMPTY,        EMPTY,      BORDER, BORDER},
                           {BORDER, BORDER, WHITE_PAWN, WHITE_PAWN,   WHITE_PAWN,   WHITE_PAWN,  WHITE_PAWN, WHITE_PAWN,   WHITE_PAWN,   WHITE_PAWN, BORDER, BORDER},
                           {BORDER, BORDER, WHITE_ROOK, WHITE_KNIGHT, WHITE_BISHOP, WHITE_QUEEN, WHITE_KING, WHITE_BISHOP, WHITE_KNIGHT, WHITE_ROOK, BORDER, BORDER},
                           {BORDER, BORDER, BORDER,     BORDER,       BORDER,       BORDER,      BORDER,     BORDER,       BORDER,       BORDER,     BORDER, BORDER},
                           {BORDER, BORDER, BORDER,     BORDER,       BORDER,       BORDER,      BORDER,     BORDER,       BORDER,       BORDER,     BORDER, BORDER}};
  
// current piece values
byte piecesValCur[12][12] = {{255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},  
                             {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255,   5,   3,   4,   9,  16,   4,   3,   5, 255, 255},
                             {255, 255,   1,   1,   1,   1,   1,   1,   1,   1, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255, 129, 129, 129, 129, 129, 129, 129, 129, 255, 255},
                             {255, 255, 133, 131, 132, 137, 144, 132, 131, 133, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}};

// previous board before last move
byte piecesValHist[12][12] = {{255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}, 
                             {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255,   5,   3,   4,   9,  16,   4,   3,   5, 255, 255},
                             {255, 255,   1,   1,   1,   1,   1,   1,   1,   1, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255,   0,   0,   0,   0,   0,   0,   0,   0, 255, 255},
                             {255, 255, 129, 129, 129, 129, 129, 129, 129, 129, 255, 255},
                             {255, 255, 133, 131, 132, 137, 144, 132, 131, 133, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}};

// [y][x] starting positions     
byte pieces[8][8] =        {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// [y][x] where current piece are located
byte piecesCurrent[8][8] = {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// [y][x] previous board before last move
byte piecesHist[8][8] =    {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// used to input the piece positions currently in the board
byte scanPieces1[8][8] =   {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// [y][x]  // used to read pieces looking for changes
byte piecesTemp1[8][8] =   {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// [y][x]  // Used to read pieces looking for changes
byte piecesTemp2[8][8] =   {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// [y][x]  // Used to read pieces looking for changes
byte piecesTemp3[8][8] =   {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// [y][x]  // used to read pieces after an error
byte piecesError[8][8] =   {{1, 1, 1, 1, 1, 1, 1, 1}, 
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {0, 0, 0, 0, 0, 0, 0, 0},
                            {1, 1, 1, 1, 1, 1, 1, 1},
                            {1, 1, 1, 1, 1, 1, 1, 1}};

// characters to produce standard chess notation
// x = columns, files, a in LL, a b c d e f g h
// y = rows, ranks, 1 in LL, 1 2 3 4 5 6 7 8

// the String rankFile(int x, int y) function will use these
String files[8] = {"a","b","c","d","e","f","g","h"};
String ranks[8] = {"8","7","6","5","4","3","2","1"};

int c;                                                      // for returned count
bool same, flag;                                            // to compare arrays and flag end of loops
byte turn = WHITE;                                          // White's turn first
byte bdCount = 32, bdCountHist;                             // 32 pieces to start, number of pieces currently in play
int pathX[30], pathY[30], pathVal[30], pathCount = 0;       // path values and total paths
int xx1, xx2, xx3, yy1, yy2, yy3;                           // active piece locations
int xKingCheck, yKingCheck, xAttackPos, yAttackPos;         // stored positions for king in check and its attacking piece
int xPathtoKing[6], yPathtoKing[6], pathtoKingCount;        // path between king and attacking piece
String message;                                             // for serial monitor output
String startPos, endPos;                                    // start and end of a move
String my_turn;                                             // store the received turn from app
byte my_piece_color, opp_piece_color;                       // store the piece colors of two players
String start_notation, end_notation;                        // for opponent's move notation
String turnFlag;                                            // store turn before changing
int fileInt, rankInt;                                       // to store position input
int start_nt_file, start_nt_rank, end_nt_file, end_nt_rank; // store the splitted opponent move notation received
bool loopEnd;                                               // mark the end of mainloop() function

// Define Pin Numbers for the Esp32 Dev Board
// connections to shift Registers of LedPanel
int dataPin = 2;    // Pin connected to SER
int latchPin = 4;   // Pin connected to RCLK
int clockPin = 5;   // Pin connected to SRCLK

// Pushbuttons to select WHITE or Black
unsigned char whButton = 18, blButton = 19;

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
//LED matrix
void clearCells();
void displayPanel();
void clearRegisters();
void writeRegisters();
void setRegisterPin(char regType, int index, boolean value);
void decodeMove(String moveNotation, String moveEnd, String moveStart);

//HallEffectSensor matrix
bool mainloop(byte turn);
int scanBoardStart(byte piecesTemp[][8]);
int scanBoard(byte piecesTemp[][8], byte piece_color);
bool comparePieceArrays(int &xx, int &yy, byte piecesCurrent[][8], byte piecesTemp1[][8]);
bool comparePieceArraysStart();
void store_retrieveHist(int dir, byte piecesValCur[][12], byte piecesValHist[][12], byte piecesCurrent[][8], byte piecesHist[][8], byte bdCount, byte bdCountHist);
void showError(byte piecesCurrent[][8], byte piecesError[][8], byte piece_color);
void showErrorOpp(byte piecesCurrent[][8], byte piecesError[][8], byte piece_color,byte x1, byte y1);
void printPaths(int x, int y);
void myDebug(int x, int y, String mess);
String namePiece(int x, int y);
void printPiecesLoc(byte pieces[][8]);
void printPiecesVal(byte pieces[][12]);
bool onPath(int xx, int yy);
int nextTurn(int turn);
bool kingInCheck(int turn);
bool checkMate(int turn);
bool squareInOpponentPath(int xx, int yy, int turn);
void pathToKingInCheck(int xKingCheck, int yKingCheck, int xAttackPos, int yAttackPos);
void getSinglePathinPaths(int xx, int yy, int xdir, int ydir, int &count, int turn);
int getPaths(byte val, int x, int y, int turn);
String rankFile(int x, int y);
int searchIndex(String arr[], String val);

void setup() {
  Serial.begin(115200);  // Set the baud rate to 115200

  ESP_BT.begin("chessMATE"); // Bluetooth device name
  Serial.println("The device started, now you can pair it with bluetooth!");
  delay(1000);
  Serial.println();

  // LedPanel
  pinMode(dataPin, OUTPUT);
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);

  pinMode(whButton, INPUT);
  pinMode(blButton, INPUT);

  // Reset all the register pins
  clearRegisters();
  writeRegisters();

  moveNotation = "";
  moveEnd = "";
  moveStart = "";

  //check for pushbutton press
  bool whButState = digitalRead(whButton), blButState = digitalRead(blButton);

  delay(2000);
  Serial.println("Choose your turn!!!");
  Serial.println();

  while((whButState == LOW) && (blButState == LOW))
  {
    whButState = digitalRead(whButton);
    blButState = digitalRead(blButton);

  }

  if(whButState == HIGH)
  {
    my_piece_color = WHITE;
    opp_piece_color = BLACK;
    Serial.println("My Piece color : WHITE");
  }
  else if(blButState == HIGH)
  {
    my_piece_color = BLACK;
    opp_piece_color = WHITE;
    Serial.println("My Piece color : BLACK");
  }

  Serial.println(" White moves first");
  delay(1000);

  // check to make sure all chess pieces are in starting positions
  do   
   {
     c = scanBoardStart(piecesTemp1);         // read the Hall Effect sensors
     Serial.print(" Pieces count : ");
     Serial.println(c);
     Serial.println();
     same = comparePieceArraysStart();
     printPiecesLoc(piecesTemp1);
   }while ((c != bdCount)|| !same );  // wait until all pieces in correct places 
   
  Serial.println("Lets Begin!!!!!");
  Serial.println();
  Serial.println("****************************************************************************");
  Serial.println();
}

void loop() {
  Serial.println("Current position matrix ");
  for (int y = 0; y < 8; y++)
    {
      for (int x = 0; x < 8; x++)
      {
        Serial.print(piecesCurrent[y][x]);

        Serial.print("  ");
      }
      Serial.println();
    }
    Serial.println();
    Serial.println();

    if(turn == WHITE)
    {
      Serial.println("--------------------- Turn : WHITE ---------------------");
    }
    else if(turn == BLACK)
    {
      Serial.println("--------------------- Turn : BLACK ---------------------");
    }
    Serial.println();
    delay(1000);
    

  if(turn == opp_piece_color)
  {
    //receive opponent's move through bluetooth
    while(!ESP_BT.available())
    {
      ESP_BT.println("Enter opponent's move - notation;start;end;op");
      ESP_BT.println("Ex -: Nf6;g8;ef6;op");
      ESP_BT.println();
      delay(1000);
    }

    // Reset all the register pins and clear the cell inorder to procede with new movement
    clearRegisters();
    writeRegisters();
    clearCells();
    
    // reads BT message --> format : moveNotation;moveStart;moveEnd
    moveNotation = ESP_BT.readStringUntil(';');
    moveStart = ESP_BT.readStringUntil(';');
    moveEnd = ESP_BT.readStringUntil(';');
    String op = ESP_BT.readStringUntil('\n');

    Serial.println();

    String notation = moveNotation;
    start_notation = moveStart;
    end_notation = moveEnd;

    Serial.print("Do the opponent's move : ");

    Serial.print(start_notation);
    start_nt_file = searchIndex(files, start_notation.substring(0,1));
    start_nt_rank = searchIndex(ranks, start_notation.substring(1));

    Serial.print(" -> ");

    Serial.print(end_notation);
    end_nt_file = searchIndex(files, end_notation.substring(0,1));
    end_nt_rank = searchIndex(ranks, end_notation.substring(1));

    Serial.println();
    
  } 

  mainloop(turn); 
  flag = true;

  if (kingInCheck(turn)) 
  {
    // if player moved a piece so their king is in check, retrieve previous values and throw and error
    store_retrieveHist(RETRIEVE, piecesValCur, piecesValHist, piecesCurrent, piecesHist, bdCount, bdCountHist);
    showError(piecesCurrent, piecesError,turn);                        // moved into check
    flag = false;
  }

  if (flag)                                  // King not in check, so next turn
  {
    if (turn == WHITE)                      
    {
      turn = BLACK;
    }
    else
    {
      turn = WHITE;
    }
    if (kingInCheck(turn))                   // This test for king in check reveals a move placing oponents king in check
    {
      // Check now for checkmate
      if (checkMate(turn))
      {
        Serial.println("checkmate");
        while(true) {}                      // loop forever
      }
    }
  }
  Serial.println();
  Serial.println("Move done : "+ startPos + " -> " + endPos);

  //send my move to app through bluetooth
  if(turn != my_piece_color)
  {
     ESP_BT.println("Move done : "+startPos+";"+endPos);
  }

}