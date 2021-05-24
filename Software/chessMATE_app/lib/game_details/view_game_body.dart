
import 'package:chessMATE_app/chessGame/chess_board.dart';
import 'package:chessMATE_app/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';
import 'display_winner.dart';

class ViewGameBody extends StatefulWidget {
  ViewGameBody({
    Key key,
    this.name,
  }) : super(key: key);

  // Name of the game
  final String name;

  @override
  _ViewGameBodyState createState() => _ViewGameBodyState();
}

class _ViewGameBodyState extends State<ViewGameBody> {
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

    // Ask to be notified when a message from the server comes in.
    game.addListener(_onAction);

  }

  @override
  void dispose() {
    game.removeListener(_onAction);
    super.dispose();
  }

  // ---------------------------------------------------------
  // when players took actions
  // Handler of these actions
  // ---------------------------------------------------------
  _onAction(message) {
    switch (message["action"]) {

      // A player resigned, so let's leave this screen
      case 'exit_game':
        Navigator.of(context).pop();
        break;

      // A player played a move. then view it
      case 'onMove':
        var data = (message["data"] as String).split(';');
        controller.makeMove(data[1], data[2]);
        gameHistory.add(data[0]);
        // Force rebuild
        setState(() {});
        break;

        case 'game_won':
          Navigator.of(context).pop(true);
          Navigator.push(context,new MaterialPageRoute(
            builder: (BuildContext context) => 
            new DisplayWinner(
            name : message["data"],
            ),
          )
          );
          break;

        case 'game_draw':
          Navigator.of(context).pop(true);
          Navigator.push(context,new MaterialPageRoute(
            builder: (BuildContext context) => 
            new DisplayWinner(
            name : " ",
            ),
          )
          );
          break;
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(4, 7, 40, 3),
        body: SafeArea(
          child: ListView(children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    "assets/logo.png",
                    height: size.height * 0.12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.white,
                          height: 5,
                          fontFamily: "Acme",
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            _buildChessBoard(),
            _buildGameHistory(),
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
        enableUserMoves: false,
        onCheckMate: (winColor) {
          // --> todo : pass the winning deatils to results screen
          Navigator.pushNamed(context, ResultsScreen.id);
        },
        onDraw: () {
          Navigator.pushNamed(context, ResultsScreen.id);
        },
        chessBoardController: controller, 
        onMove: (String moveNotation, String from, String to) {  },
      ),
    );
  }

  // method to return a widget containing gameHistory
  Widget _buildGameHistory() {
    return Text(
      _buildMovesString(),
      style: TextStyle(color: Colors.white),
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
