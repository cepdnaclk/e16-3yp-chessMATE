import 'package:chessMATE_app/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class PlayGame extends StatefulWidget {
  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  static ChessBoardController controller;
  static List<String> gameHistory = [];

  // will call this method exactly once for each [State] object it creates.
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]); // fix the orientation up for this game interface
    controller = ChessBoardController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "chessMATE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.grey,
                      fontFamily: "Audiowide",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "White : " + "_PlayerName_    ",
                      style: TextStyle(
                          color: Colors.black,
                          height: 5,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Black : " + "_PlayerName_",
                      style: TextStyle(
                          color: Colors.black,
                          height: 5,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            _buildChessBoard(),
            _buildGameHistory(),
            _buildOptionButtons(),
          ]),
        ),
      ),
    );
  }

  // method to return the chessboard widget
  Widget _buildChessBoard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ChessBoard(
        size: MediaQuery.of(context).size.width,
        onMove: (moveNotation) {
          gameHistory.add(moveNotation);
          setState(() {});
        },
        onCheckMate: (winColor) {
          // --> todo : pass the winning deatils to results screen
          //Navigator.pushNamed(context, ResultsScreen.id);
        },
        onDraw: () {
          // Navigator.pushNamed(context, ResultsScreen.id);
        },
        chessBoardController: controller,
      ),
    );
  }

  // method to return the widget containing option buttons
  Widget _buildOptionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Reset Game"),
                  color: Colors.grey[400],
                  textColor: Colors.black,
                  onPressed: () {
                    _resetGame();
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Undo Move"),
                  color: Colors.grey[400],
                  textColor: Colors.black,
                  onPressed: () {
                    _undoMove();
                  },
                ),
              ),
            ),
          ]),
    );
  }

  // method to reset the game
  void _resetGame() {
    controller.resetBoard();
    gameHistory.clear();
    setState(() {});
  }

  // method to undo the last move
  void _undoMove() {
    controller.game.undo_move();
    if (gameHistory.length != 0) {
      gameHistory.removeLast();
    }
    setState(() {});
  }

  // method to return a widget containing gameHistory
  Widget _buildGameHistory() {
    return Text(
      _buildMovesString(),
      style: TextStyle(color: Colors.black),
    );
  }

  // method to retun the gamehistory as a string
  String _buildMovesString() {
    String history = '';
    if (gameHistory.length > 0) {
      for (int i = 0; i < gameHistory.length; i++) {
        if (i % 2 == 0) {
          history += "${(i / 2 + 1).toInt()}" + "." + gameHistory[i] + " ";
          if (gameHistory.length > (i + 1)) {
            history += gameHistory[i + 1] + "   ";
          }
        }
      }
    }
    return history;
  }
}
