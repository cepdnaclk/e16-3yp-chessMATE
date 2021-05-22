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

// set of functions need
int mainloop(byte turn);
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

  //receive piece color through bluetooth
  while(!ESP_BT.available())
  {
    ESP_BT.println("Enter your turn!!!");
    ESP_BT.println();
    delay(1000);
  }
  my_turn = ESP_BT.readStringUntil('\n');
  Serial.println("My Piece color : " + my_turn);
  if(my_turn[0] == 'W')
  {
    my_piece_color = WHITE;
    opp_piece_color = BLACK;
  }
  else if(my_turn[0] == 'B')
  {
    my_piece_color = BLACK;
    opp_piece_color = WHITE;
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
      ESP_BT.println("Enter opponent's move notation - start;end;op !!!");
      ESP_BT.println("Ex -: e7;e6;op");
      ESP_BT.println();
      delay(1000);
    }
    start_notation = ESP_BT.readStringUntil(';');
    end_notation = ESP_BT.readStringUntil(';');
    String opp = ESP_BT.readStringUntil('\n');

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
}



int mainloop(byte turn)
{
  bool flag;                                // Used for ending the do loop
  int total1 = 0, total2 = 0, total3 = 0;   // For different reads of total number of pieces on the board

  do
  {
    flag = false;
    do
    {
      
      total1 = scanBoard(piecesTemp1,turn);       // Read the Hall Effect sensors
    }while (total1 == bdCount);    

    comparePieceArrays(xx1, yy1, piecesCurrent, piecesTemp1);     //xx1, yy1 is the space with piece removed
    if (((turn == WHITE) && (piecesValCur[yy1 + 2][xx1 + 2] < WHITE_PAWN)) ||  // Make sure right color takes turn
        ((turn == BLACK) && (piecesValCur[yy1 + 2][xx1 + 2] > BLACK_KING)))
    {
      showError(piecesCurrent, piecesError,turn);   // Throw error is not right colorn
      flag = true;
      continue;
    }

    
    myDebug(xx1, yy1, "Piece removed at");

    if(turn == opp_piece_color)
      {
        if((start_nt_file != fileInt) || (start_nt_rank != rankInt))
        {
          Serial.println();
          Serial.println("Wrong start position!!!!!!");
          Serial.println();
          showErrorOpp(piecesCurrent, piecesError,turn,xx1,yy1);
          flag = true;
          continue;
        }
      }

    message = namePiece(xx1, yy1) + rankFile(xx1, yy1);
    startPos = rankFile(xx1, yy1);
    Serial.println(message);
    pathCount = 0;
    int paths = getPaths(piecesValCur[yy1 + 2][xx1 + 2], xx1, yy1, turn); // Get all legal paths (squares) 
                                                                          // If no paths, no green or yellow squares
    do
    {
      total2 = scanBoard(piecesTemp2,turn);            // Read the Hall Effect sensors
    }while (total2 == total1);                   // Wait for a change

    

    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    if (bdCount - total2 == 2)                   // Second piece removed - so this should be a capture
    {
       
      comparePieceArrays(xx2, yy2, piecesTemp2, piecesTemp1);     // xx2, yy2 will be position of 2nd piece removed
      for (int i=0; i < pathCount; i++)
      {
        if ((pathX[i] == xx2) && (pathY[i] == yy2))               // found the 2nd piece
        {
          
          myDebug(xx2, yy2, "Second piece removed at");           // More debugging output

          if(turn == opp_piece_color)
          {
            if((end_nt_file != fileInt) || (end_nt_rank != rankInt))
            {
              Serial.println();
              Serial.println("Wrong capture position!!!!!!");
              Serial.println();
              showErrorOpp(piecesCurrent, piecesError,turn,xx2,yy2);
              flag = true;
              continue;
            }
          }
          Serial.println(namePiece(xx2, yy2));
          do
          {
            total3 = scanBoard(piecesTemp3,turn);                       // Read the Hall Effect sensors
          }while (total2 == total3);                                    // Wait for a change, the piece show be                            
          
                                                                  // replaced on the captured piece's square
          comparePieceArrays(xx3, yy3, piecesTemp3, piecesTemp2);
          if ((xx2 == xx3) && (yy2 == yy3))                       // Captured piece and replaced piece
          {                                                       // square should be the same
            // save previous board positions and values
            store_retrieveHist(STORE, piecesValCur, piecesValHist, piecesCurrent, piecesHist, bdCount, bdCountHist);
            message = rankFile(xx2, yy2);
            Serial.println(message);
          
            message = namePiece(xx2, yy2) + rankFile(xx2, yy2);
            
         
            Serial.println();
            Serial.println("Captured!!!!!");
            Serial.println();
            piecesCurrent[yy1][xx1] = 0;
            piecesCurrent[yy2][xx2] = 1;                          // actually piece already there
            piecesValCur[yy2 + 2][xx2 + 2] = piecesValCur[yy1 + 2][xx1 + 2];    
            piecesValCur[yy1 + 2][xx1 + 2] = 0;
            bdCount = bdCount - 1;
            flag = true;
            continue;
          }
        }
      }
      if (flag)             // 2nd piece was captured and removed
      {
        flag = false;       // this will end our do loop
        continue;
      }
      else
      {
        // Flag wasn't set to true above so captured piece and replaced piece 
        // in different locations, an error
        showError(piecesCurrent, piecesError,turn);
      }
    }

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    if (comparePieceArrays(xx2, yy2, piecesCurrent, piecesTemp2) == true) // arrays are the same
    {
      flag = true;          // Continue the do loop

      Serial.println(" Piece returned");
      continue;
    }

    // This section processes a simple move with no capture
     comparePieceArrays(xx2, yy2, piecesTemp1, piecesTemp2);
     
     
     myDebug(xx2, yy2, "Piece down at");
     if(turn == opp_piece_color)
      {
        if((end_nt_file != fileInt) || (end_nt_rank != rankInt))
        {
          Serial.println();
          Serial.println("Wrong end position!!!!!!");
          Serial.println();
          showErrorOpp(piecesCurrent, piecesError,turn,xx2,yy2);
          flag = true;
          continue;
          }
        }
     if (!onPath(xx2, yy2))                     // Check to make sure piece was place on an allowable square
     {
        showError(piecesCurrent, piecesError,turn);
        flag = true;
       continue;
     }
     

     
     // Save previous board positions and values, this is for possible king in check detected later 
     store_retrieveHist(STORE, piecesValCur, piecesValHist, piecesCurrent, piecesHist, bdCount, bdCountHist);
     // If we get here piece was moved from xx1, yy1 to xx2, yy2
     // Write the new values into piecesCurrent and piecesValCur arrays
     piecesCurrent[yy1][xx1] = 0;
     piecesCurrent[yy2][xx2] = 1;
     piecesValCur[yy2 + 2][xx2 + 2] = piecesValCur[yy1 + 2][xx1 + 2];
     piecesValCur[yy1 + 2][xx1 + 2] = 0;
     message = rankFile(xx2, yy2);
     Serial.println(message);
      
     } while (flag); 
  pathCount = 0;      // Reset the pathCount
  Serial.println();
  Serial.println("Through mainLoop");
  Serial.println();
  return 0;
}

//*************************************************************************************************************************
// scan the board at begining
int scanBoardStart(byte piecesTemp[][8])
{
  
    int count = 0;
    for (int y = 0; y < 8; y++)
    {
      for (int x = 0; x < 8; x++)
      {
        piecesTemp[y][x] = scanPieces1[y][x];
        if (scanPieces1[y][x] == 0x01)
        {
          count++;        
        }
      }
    }
    return count; 
}

//*************************************************************************************************************************
// scan the board except at begining
int scanBoard(byte piecesTemp[][8], byte piece_color)
{
  if(Serial.available()>0)
  {
    // get the chess notations as strings
    String y1 = Serial.readStringUntil(';');
    String x1 = Serial.readStringUntil(';');
    String ch = Serial.readStringUntil('\n');
    Serial.println();
    Serial.println("file : "+y1);
    Serial.println("rank : "+x1);
    Serial.println("action : "+ch);
    
    // find the coordinates in the matrix corresponding to the chess notations
    int x = searchIndex(files, y1); //column
    int y = searchIndex(ranks, x1); //row

    fileInt = x;
    rankInt = y;

    Serial.print("Matrix Coordinates : ( ");
    Serial.print(y);
    Serial.print(" , ");
    Serial.print(x);
    Serial.print(" ) ");
    Serial.println();

    if(ch.equals("remove"))
    {
      scanPieces1[y][x] = 0;    
    }
    else if(ch.equals("return"))
    {
      scanPieces1[y][x] = 1;
      endPos = y1 + x1;
    }    
  }
    int count = 0;
    for (int y = 0; y < 8; y++)
    {
      for (int x = 0; x < 8; x++)
      {
        piecesTemp[y][x] = scanPieces1[y][x];
        if (scanPieces1[y][x] == 0x01)
        {
          count++;        
        }
      }
    }
    return count;   
}

// *************************************************************************************************************************
// compare piece arrays
bool comparePieceArrays(int &xx, int &yy, byte piecesCurrent[][8], byte piecesTemp1[][8])
{
  for (int y = 0; y < 8; y++)
  {
    for (int x = 0; x < 8; x++)
    {
      if (piecesTemp1[y][x] != piecesCurrent[y][x])
      {
        // First piece that doesn't match previous,
        // Write to xx, yy and return
        xx = x; yy = y;
        return false;         // arrays are different
      }
    }
  }
  return true;                // arrays are the same
}

// *************************************************************************************************************************
// compare piece arrays at the begining
bool comparePieceArraysStart()
{
  for (int y = 0; y < 8; y++)
  {
    for (int x = 0; x < 8; x++)
    {
      if (piecesTemp1[y][x] != pieces[y][x])
      {
        return false;         // arrays are different
      }
    }
  }
  return true;                // arrays are the same
}

// ************************************************************************************************************************
// store or retrieve prievous board settings to be able to undo a move
void store_retrieveHist(int dir, byte piecesValCur[][12], byte piecesValHist[][12], byte piecesCurrent[][8], byte piecesHist[][8], byte bdCount, byte bdCountHist)
{
  // This is just a brute force store or retrieve of all the piece positions and values on the board.
  // The borders could have been eliminated.
  for (int y = 0; y < 12; y++)
    {
      for (int x = 0; x < 12; x++)
      {
        if (dir == STORE)
        {
          piecesValHist[y][x] = piecesValCur[y][x];
        }
        else if (dir == RETRIEVE)
        {
          piecesValCur[y][x] = piecesValHist[y][x];
        }
      }
    }

    for (int y = 0; y < 8; y++)
    {
      for (int x = 0; x < 8; x++)
      {
        if (dir == STORE)
        {
          piecesHist[y][x] = piecesCurrent[y][x];
        }
        else if (dir == RETRIEVE)
        {
          piecesCurrent[y][x] = piecesHist[y][x];
        }
      }
    }

    if (dir == STORE)
    {
      bdCountHist = bdCount;
    }
    else if (dir == RETRIEVE)
    {
      bdCount = bdCountHist;
    }
}

// *************************************************************************************************************************
// show an error state and wait for correction, ie. all pieces replaced to positions before the error
void showError(byte piecesCurrent[][8], byte piecesError[][8], byte piece_color)
{
  bool flag;
  int total;

  do
  {
    flag = true;
    total = scanBoard(piecesError, piece_color);
    for (int y = 0; y < 8; y++)
    {
      for (int x = 0; x < 8; x++)
      {
        if (piecesError[y][x] != piecesCurrent[y][x])
        {
          myDebug(x, y, "Error here");
          delay(1000);
          flag = false;
          break;
        }
        if (flag == false) break;   // needed for double loop
      }
    }
  } while (flag == false);
  Serial.println("Error is over!! Re-enter the correct move!!");
}

// *************************************************************************************************************************
// Show an error state and wait for correction, ie. all pieces replaced to positions before the error
void showErrorOpp(byte piecesCurrent[][8], byte piecesError[][8], byte piece_color,byte x1, byte y1)
{
  bool flag;
  int total;

  do
  {
    flag = true;
    total = scanBoard(piecesError, piece_color);
    for (int y = 0; y < 8; y++)
    {
      for (int x = 0; x < 8; x++)
      {
        if (piecesError[y][x] != piecesCurrent[y][x])
        {
          Serial.println("Error!! Return the piece back!!");
          //myDebug(x1, y1, "Error here");
          delay(1000);
          flag = false;
          break;
        }
        if (flag == false) break;   // needed for double loop
      }
    }
  } while (flag == false);
  Serial.println("Error is over!! Re-enter the correct move!!");
}

// ************************************************************************************************************************
// print the paths to the Serial monitor for debugging
void printPaths(int x, int y)
{
  Serial.print("Paths for ");
  Serial.println(namePiece(x, y));
  for (int i = 0; i < pathCount; i++)
  {
    Serial.print(pathX[i]);
    Serial.print("   ");
    Serial.print(pathY[i]);
    Serial.print("   ");
    Serial.print(pathVal[i]);
    Serial.println();
  }
  Serial.println("***********");
}

// ************************************************************************************************************************
// myDebug, print two numbers and a string to the Serial monitor for debugging
void myDebug(int x, int y, String mess)
{
  Serial.print(mess);
  Serial.print("   ");
  Serial.print(x);
  Serial.print("   ");
  Serial.print(y);
  Serial.println("   ");
  
}

// *************************************************************************************************************************
// the name of the piece for LCD readout and debugging
String namePiece(int x, int y)
{
  switch (piecesValCur[y + 2][x + 2])
  {
    case 0: return "Empty ";
            break;
    case 1: return "Black Pawn ";
            break;
    case 3: return "Black Knight ";
            break;
    case 4: return "Black Bishop ";
            break;
    case 5: return "Black Rook ";
            break;
    case 9: return "Black Queen ";
            break;
    case 16: return "Black King ";
            break;
    case 129: return "White Pawn ";
            break;
    case 131: return "White Knight ";
            break;
    case 132: return "White Bishop ";
            break;
    case 133: return "White Rook ";
            break;
    case 137: return "White Queen ";
            break;
    case 144: return "White King ";
            break;
  }
  return "ERROR";
}

// *************************************************************************************************************************
// print the piece locations to the Serial monitor for debugging
void printPiecesLoc(byte pieces[][8])
{
  for (int y = 0; y < 8; y++)
  {
    for (int x = 0; x < 8; x++)
    {
      // The if statements space things nicely
      if (pieces[y][x] < 10) Serial.print("  ");
      if ((pieces[y][x] >= 10) && (pieces[y][x] < 100)) Serial.print(" ");
      Serial.print(pieces[y][x]);
      Serial.print("  ");
    }
    Serial.println();
    Serial.println();
  }
  Serial.println();
  Serial.println();
}

// *************************************************************************************************************************
// print the piece values to the Serial monitor for debugging
void printPiecesVal(byte pieces[][12])
{
  for (int y = 2; y < 10; y++)
  {
    for (int x = 2; x < 10; x++)
    {
      // The if statements space things nicely
      if (pieces[y][x] < 10) Serial.print("  ");
      if ((pieces[y][x] >= 10) && (pieces[y][x] < 100)) Serial.print(" ");
      Serial.print(pieces[y][x]);
      Serial.print("  ");
    }
    Serial.println();
    Serial.println();
  }
  Serial.println();
  Serial.println();
}

// *************************************************************************************************************************
// is position on a path?
bool onPath(int xx, int yy)
{
  for (int i = 0; i < pathCount; i++)
  {
    if ((xx == pathX[i]) && (yy == pathY[i]))
    {
      return true;    // When we find position on path return
    }
  }
  return false;       // Position not on path
}

// *************************************************************************************************************************
// Toggles turn for certain use of getPaths
int nextTurn(int turn)
{
  // This just return the opposite of turn, ie. the next turn
  int t;
  if (turn == BLACK)
  {
    t = WHITE;
  }
  else
  {
    t = BLACK;
  }
  return t;
}

// *************************************************************************************************************************
// is the King in check ?
bool kingInCheck(int turn)
{
  // This one is tricky, we go though entire array looking for the next turn's pieces
  // Then we find the paths for the next turn's pieces and if the turn's king
  // is on one of these paths then that king will be in check. We color the square
  // with the piece that puts the king in check violet.
  pathCount = 0;
  for (int y = 0; y < 8; y++)
  {
    for (int x = 0; x < 8; x++)
    {
      if (((turn == WHITE) && (piecesValCur[y + 2][x + 2] >= BLACK_PAWN) && (piecesValCur[y + 2][x + 2] <= BLACK_KING)) ||
          ((turn == BLACK) && (piecesValCur[y + 2][x + 2] >= WHITE_PAWN) && (piecesValCur[y + 2][x + 2] <= WHITE_KING)))
      {
       // Serial.println(piecesValCur[y + 2][x + 2]);
       // myDebug(x, y, "Square");
        getPaths(piecesValCur[y + 2][x + 2], x, y, nextTurn(turn));
        // printPaths(x, y);
        for (int i = 0; i < pathCount; i++)
        {
           if (((pathVal[i] == BLACK_KING) && (turn == BLACK)) || ((pathVal[i] == WHITE_KING) && (turn == WHITE)))
           {
              
              if (turn == BLACK)
              {
                Serial.println("Black King in Check");
               
              }
              else 
              {
                Serial.println("White King in Check");
                
              }
              myDebug(pathX[i], pathY[i], namePiece(pathX[i], pathY[i]));
              // Save the position of the king in check
              xKingCheck = pathX[i]; yKingCheck = pathY[i];
              // Save the position of the attacking piece
              myDebug(x, y, "Attacking piece");
              xAttackPos = x; yAttackPos = y;
              pathToKingInCheck(xKingCheck, yKingCheck, xAttackPos, yAttackPos);
//              colorSquare(xAttackPos, yAttackPos, colors[VIOLET], true);
//              colorSquare(xKingCheck, yKingCheck, colors[VIOLET], true);
              pathCount = 0;
              return true;
           }
        }
        pathCount = 0;
      }
    }
  }
  return false;
}

// ***************************************************************************************************************************
// are we in checkmate ? return true if in checkmate
bool checkMate(int turn)
{
  // Function kingInCheck has stored king position in xKingCheck, yKingCheck, and also stored 
  // xAttackPos and yAttackPos of attacking piece.
  // pathToKingInCheck(xKingCheck, yKingCheck, xAttackPos, yAttackPos) stores the path between
  // the two in int variables xPathtoKing[6], yPathtoKing[6], and pathtoKingCount

  // can the king move to get out of check
  // get the paths for the king which is in check
  getPaths(piecesValCur[yKingCheck + 2][xKingCheck + 2], xKingCheck, yKingCheck, turn);
  printPaths(xKingCheck, yKingCheck);
  // pathtoKingCount needs to be zeroed before returning this function
  for (int i = 0; i < pathCount; i++)        // paths king can move to
  {
    for (int j = 0; j < pathtoKingCount; j++)  // attack path to king
    {
      if (!((pathX[i] == xPathtoKing[j]) && (pathY[i] == yPathtoKing[j])))
      {
        // There is a square the king can move to that is not on the path
        // from the attacking piece to the king, but will king move into check from another piece?
        myDebug(pathX[i], pathY[i], "Path king can move to");
        if (squareInOpponentPath(pathX[i], pathY[i], turn))
        {
          // this square will have king in check if king moves there 
          continue;
        }
        else
        {
          // square is open - no checkmate
         
          pathtoKingCount = 0;
          pathCount = 0;
          return false;
        }
      }
    }
  }

  // now we check to see if we can move a piece to block attacking piece

  for (int y = 0; y < 8; y++)
  {
    for (int x = 0; x < 8; x++)
    {
      if (((turn == BLACK) && (piecesValCur[y + 2][x + 2] >= BLACK_PAWN) && (piecesValCur[y + 2][x + 2] <= BLACK_QUEEN)) ||
          ((turn == WHITE) && (piecesValCur[y + 2][x + 2] >= WHITE_PAWN) && (piecesValCur[y + 2][x + 2] <= WHITE_QUEEN)))
      {
        pathCount = 0;
        getPaths(piecesValCur[y + 2][x + 2], x, y, turn);
        // printPaths(x, y);
        for (int i = 0; i < pathCount; i++)
        {
          for (int j = 0; j < pathtoKingCount; j++)
          {
            if (((pathX[i] == xPathtoKing[j]) && (pathY[i] == yPathtoKing[j])) ||   // piece can move to attacking path
                ((pathX[i] == xAttackPos) && (pathY[i] == yAttackPos)))             // or can capture the attacking piece
            {
              // we can block attacking piece
              myDebug(pathX[i], pathY[i], "Blocking piece for king");
              pathtoKingCount = 0;
              pathCount = 0;
              return false;
            }
          }
        }
      }
    }
  }
  pathtoKingCount = 0;
  // if we get here, checkmate
  Serial.println("    CHECKMATE!      ");
  return true;
}

// ***************************************************************************************************************************
// if king moves to this path will it be in check, ie. moves into path of opponent
bool squareInOpponentPath(int xx, int yy, int turn)
{
  for (int y = 0; y < 8; y++)
  {
    for (int x = 0; x < 8; x++)
    {
      if (((turn == WHITE) && (piecesValCur[y + 2][x + 2] >= BLACK_PAWN) && (piecesValCur[y + 2][x + 2] <= BLACK_QUEEN)) ||
          ((turn == BLACK) && (piecesValCur[y + 2][x + 2] >= WHITE_PAWN) && (piecesValCur[y + 2][x + 2] <= WHITE_QUEEN)))
      {
        getPaths(piecesValCur[y + 2][x + 2], x, y, nextTurn(turn));
        for (int i = 0; i < pathCount; i++)
        {
          if ((pathX[i] == xx) && (pathY[i] == yy))
          {
            return true;
          }
        }
      }
    }
  }
  return false;
}

// ***************************************************************************************************************************
// get path from king to attacking piece
void pathToKingInCheck(int xKingCheck, int yKingCheck, int xAttackPos, int yAttackPos)
{
  int xPath, yPath, xMove, yMove, count = 0;
  switch(piecesValCur[yAttackPos + 2][xAttackPos + 2])
  {
    // make sure it's the right find of piece to create a path to king
    case BLACK_BISHOP: break;
    case BLACK_ROOK:   break;
    case BLACK_QUEEN:  break;
    case WHITE_BISHOP: break;
    case WHITE_ROOK:   break;
    case WHITE_QUEEN:  break;
    default:  pathtoKingCount = 0;
              return;
              break;
  }
  if (xKingCheck == xAttackPos)
  {
    xMove = 0;
  }
  else if (xKingCheck < xAttackPos)
  {
    xMove = 1;
  }
  else
  {
    xMove = -1;
  }

  if (yKingCheck == yAttackPos)
  {
    yMove = 0;
  }
  else if (yKingCheck < yAttackPos)
  {
    yMove = 1;
  }
  else
  {
    yMove = -1;
  }
  
  xPath = xKingCheck + xMove;
  yPath = yKingCheck + yMove;
  while ((xPath != xAttackPos) && (yPath != yAttackPos))
  {
    xPathtoKing[count] = xPath;
    yPathtoKing[count] = yPath;
    myDebug(xPathtoKing[count], yPathtoKing[count], "Along the path to King");
    count++;
    xPath += xMove;
    yPath += yMove;
  }
  pathtoKingCount = count;
}

// *************************************************************************************************************************
// follow a single path to its end
void getSinglePathinPaths(int xx, int yy, int xdir, int ydir, int &count, int turn)
{
  // This function starts with the xx, yy position of a square and xdir and ydir directions to add to the square's
  // position with every loop. The loop continues as long as the squares are EMPTY. When it hits a square occupied
  // it checks to be sure it is an opponent's piece and then will add this to the path.
  xx = xx + xdir;
  yy = yy + ydir;
  while (piecesValCur[yy][xx] == EMPTY)
  {
    pathY[count] = yy - 2; pathX[count] = xx - 2; pathVal[count] = piecesValCur[yy][xx];
    count++;
    xx = xx + xdir;
    yy = yy + ydir;
  }
  if (((turn == WHITE) && (piecesValCur[yy][xx] >= BLACK_PAWN) && (piecesValCur[yy][xx] <= BLACK_KING)) ||
      ((turn == BLACK) && (piecesValCur[yy][xx] >= WHITE_PAWN) && (piecesValCur[yy][xx] <= WHITE_KING)))
  {
    pathY[count] = yy - 2; pathX[count] = xx - 2; pathVal[count] = piecesValCur[yy][xx]; count++;
  }
}

// *************************************************************************************************************************
// get the legal positions a piece can move to
int getPaths(byte val, int x, int y, int turn)
{
  // This function starts with a position, and the piece (val) in that position, and gets the legal paths (the squares 
  // where that piece can legally move) for that piece. The path is stored in arrays  pathX[30], pathY[30], pathVal[30], 
  // and pathCount contains number of squares stored in the arrays. Two different methods are used. For the pawns, knights 
  // and kings a brute force method, where the legal moves are stored in arrays, or scanned in the case of the king. For the 
  // bishops, rooks and queens we use the function getSinglePathinPaths() to follow each line of squares where the piece can 
  // legally move. For the bishops, rooks and queens, each legal direction is placed in the calls to getSinglePathinPaths().
  
  int xx, yy;
  // Pawn ************************************************************************************ Pawn Pawn Pawn Pawn Pawn 
  if ((val == BLACK_PAWN) || (val == WHITE_PAWN))
  {
    // First 2 are straight ahead moves
    int wPawnX[4] = { 0, 0,-1, 1};
    int wPawnY[4] = {-1,-2,-1,-1};
    int bPawnX[4] = { 0, 0,-1, 1};
    int bPawnY[4] = { 1, 2, 1, 1};
    
    for (int i = 0; i < 4; i++)
    {
      if (i == 1) continue;           // The test for the second square is in the i = 0 block
      if (i == 0)
      {
        if (((turn == WHITE) && (piecesValCur[y + 2 + wPawnY[i]][x + 2 + wPawnX[i]] == EMPTY)) ||
            ((turn == BLACK) && (piecesValCur[y + 2 + bPawnY[i]][x + 2 + bPawnX[i]] == EMPTY)))
        {
          if (turn == WHITE)
          {
            pathY[pathCount] = y + wPawnY[i]; pathX[pathCount] = x + wPawnX[i]; pathVal[pathCount] = piecesValCur[y + 2 + wPawnY[i]][x + 2 + wPawnX[i]]; pathCount++;
          }
          else
          {
            pathY[pathCount] = y + bPawnY[i]; pathX[pathCount] = x + bPawnX[i]; pathVal[pathCount] = piecesValCur[y + 2 + bPawnY[i]][x + 2 + bPawnX[i]]; pathCount++;
          }
          if (((piecesValCur[y + 2 + wPawnY[i + 1]][x + 2 + wPawnX[i + 1]] == EMPTY) && (y == 6)) ||    // pawn in rank 2, starting position
              ((piecesValCur[y + 2 + bPawnY[i + 1]][x + 2 + bPawnX[i + 1]] == EMPTY) && (y == 1)))      // pawn in rank 7, starting position
          {
              if (turn == WHITE)
              {
                pathY[pathCount] = y + wPawnY[i + 1]; pathX[pathCount] = x + wPawnX[i + 1]; pathVal[pathCount] = piecesValCur[y + 2 + wPawnY[i + 1]][x + 2 + wPawnX[i + 1]]; pathCount++;
              }
              else
              {
                pathY[pathCount] = y + bPawnY[i + 1]; pathX[pathCount] = x + bPawnX[i + 1]; pathVal[pathCount] = piecesValCur[y + 2 + bPawnY[i + 1]][x + 2 + bPawnX[i + 1]]; pathCount++;
              }
          }
        }
      }
      else // i = 2 or 3, can pawn take a piece ?
      {
        if (((turn == WHITE) && (piecesValCur[y + 2 + wPawnY[i]][x + 2 + wPawnX[i]] >= BLACK_PAWN) && (piecesValCur[y + 2 + wPawnY[i]][x + 2 + wPawnX[i]] <= BLACK_KING)) ||
            ((turn == BLACK) && (piecesValCur[y + 2 + bPawnY[i]][x + 2 + bPawnX[i]] >= WHITE_PAWN)))
        {
          if (turn == WHITE)
          {
            pathY[pathCount] = y + wPawnY[i]; pathX[pathCount] = x + wPawnX[i]; pathVal[pathCount] = piecesValCur[y + 2 + wPawnY[i]][x + 2 + wPawnX[i]]; pathCount++;
          }
          else
          {
            pathY[pathCount] = y + bPawnY[i]; pathX[pathCount] = x + bPawnX[i]; pathVal[pathCount] = piecesValCur[y + 2 + bPawnY[i]][x + 2 + bPawnX[i]]; pathCount++;
          }
        }
      }
    }
  }

  // Knight *************************************************************************** Knight Knight Knight Knight 
  if ((val == BLACK_KNIGHT) || (val == WHITE_KNIGHT))
  {
    // x and y are the starting positions
    int i[8] = {1, 2, -1, -2, -1, -2, 1, 2};
    int j[8] = {2, 1, -2, -1,  2,  1,-2,-1};
    // myDebug(x, y, "  x and y coming in");
    // Check all eight possible moves
    for (int k = 0; k < 8; k++)
    {
      xx = x + 2 + i[k]; yy = y + 2 + j[k];
      if (((turn == WHITE) && (piecesValCur[yy][xx] >= BLACK_PAWN) && (piecesValCur[yy][xx] <= BLACK_KING)) ||
          ((turn == BLACK) && (piecesValCur[yy][xx] >= WHITE_PAWN) && (piecesValCur[yy][xx] <= WHITE_KING)) ||
           (piecesValCur[yy][xx] == EMPTY))
      {
        pathY[pathCount] = yy - 2; pathX[pathCount] = xx - 2; pathVal[pathCount] = piecesValCur[yy][xx]; pathCount++;
      }
    }
  }

  // Bishop *************************************************************************** Bishop Bishop Bishop Bishop 
  if ((val == BLACK_BISHOP) || (val == WHITE_BISHOP))
  {
    getSinglePathinPaths(x + 2, y + 2, 1, 1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2,-1,-1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2, 1,-1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2,-1, 1, pathCount, turn);
  }

  // Rook ******************************************************************************* Rook Rook Rook Rook Rook 
  if ((val == BLACK_ROOK) || (val == WHITE_ROOK))
  {
    getSinglePathinPaths(x + 2, y + 2, 1, 0, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2,-1, 0, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2, 0, 1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2, 0,-1, pathCount, turn);
  }

  // Queen ******************************************************************************* Queen Queen Queen Queen 
  if ((val == BLACK_QUEEN) || (val == WHITE_QUEEN))
  {
    // x and y are the starting positions
    getSinglePathinPaths(x + 2, y + 2, 1, 1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2,-1,-1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2, 1,-1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2,-1, 1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2, 1, 0, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2,-1, 0, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2, 0, 1, pathCount, turn);
    getSinglePathinPaths(x + 2, y + 2, 0,-1, pathCount, turn);
  }

  // King ********************************************************************************* King King King King King 
  if ((val == BLACK_KING) || (val == WHITE_KING))
  {
    //myDebug(x, y, "  x and y coming in");
    for (int i = -1; i < 2; i++)
    {
       xx = x + 2 + i;
      for (int j = -1; j < 2; j++)
      {
        yy = y + 2 + j;
        if (!((i == 0) && (j == 0)))
        {
         // myDebug(xx - 2, yy - 2, "Square for King path");
          if (((turn == WHITE) && (piecesValCur[yy][xx] >= BLACK_PAWN) && (piecesValCur[yy][xx] <= BLACK_KING)) ||
              ((turn == BLACK) && (piecesValCur[yy][xx] >= WHITE_PAWN) && (piecesValCur[yy][xx] <= WHITE_KING)) ||
               (piecesValCur[yy][xx] == EMPTY))
          {
            pathY[pathCount] = yy - 2; pathX[pathCount] = xx - 2; pathVal[pathCount] = piecesValCur[yy][xx]; pathCount++;
          }
        }
      }
    }
  }
  return pathCount;
}

// ************************************************************************************************************************
// return the traditional rank and file notation denoting the position of a square, so position 3,4 equals d5
// this is used for output to the LCD display
String rankFile(int x, int y)
{
  // this turns an x,y position into standard chess rank file notation and returns a string
  // x = columns, files, a in LL, a b c d e f g h
  // y = rows, ranks, 1 in LL, 1 2 3 4 5 6 7 8 
  String message = files[x] + ranks[y];
  return message;
}

//***************************************************************************************************************************
//search for index of a given string value in a string array
int searchIndex(String arr[], String val)
{
  int index = 0;
  while(index < 8 && !arr[index].equals(val))
  {
    ++index;
  }

  return index;
}