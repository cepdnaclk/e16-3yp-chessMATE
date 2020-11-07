import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class PlayGame extends StatefulWidget{
  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame>{

  static ChessBoardController controller;
  static List<String> gameHistory;

  // will call this method exactly once for each [State] object it creates.
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);  // fix the orientation up for this game interface
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
          child: Column(
            children: <Widget>[
              _buildChessBoard(),
              // -buildOptionButtons(),
              Expanded(
                child: FittedBox(
                fit: BoxFit.contain,
                  // child: _buildGameHistory(),
                ),
              ),
            ]
          ),
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

}