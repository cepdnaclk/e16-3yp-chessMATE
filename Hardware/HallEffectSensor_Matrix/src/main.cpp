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

// used to input the piece positions
byte scanPieces[8][8] =   {{1, 1, 1, 1, 1, 1, 1, 1}, 
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

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
}