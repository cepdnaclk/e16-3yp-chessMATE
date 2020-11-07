import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class PlayGame extends StatefulWidget {
  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  static ChessBoardController controller;
  static List<String> gameHistory;

  // will call this method exactly once for each [State] object it creates.
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]); // fix the orientation up for this game interface
    controller = new ChessBoardController();
    gameHistory = [];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ChessMATE'),
        ),
        body: SafeArea(
          child: Column(children: <Widget>[
            _buildChessBoard(),
            _buildOptionButtons(),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: _buildGameHistory(),
              ),
            ),
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
          // Navigator.pushNamed(context, ResultsScreen.id);
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
                  child: Text("Reset game"),
                  color: Colors.blue,
                  textColor: Colors.white,
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
                  child: Text("undo Move"),
                  color: Colors.blue,
                  textColor: Colors.white,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(_buildMovesString()),
    );
  }

  // method to retun the gamehistory as a string
  String _buildMovesString() {
    String history = '';
    for (int i = 0; i < gameHistory.length; i++) {
      if (i % 2 == 0) {
        history += (i / 2 + 1).toString() + "." + gameHistory[i] + " ";
      } else {
        history += " " + gameHistory[i] + "  ";
      }
    }
    return history;
  }
}
