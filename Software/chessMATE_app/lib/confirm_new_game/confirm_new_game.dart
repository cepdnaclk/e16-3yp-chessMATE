
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';
import 'package:chessMATE_app/chessGame/buildGame.dart';
import 'package:chessMATE_app/confirm_new_game/confirm_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmNewGame extends StatefulWidget {
  ConfirmNewGame({
    Key key,
    this.opponentName, 
    this.opponentId,
    this.willStream,
  }) : super(key: key);

  // Name of the opponent
  final String opponentName;

  // Yes or No 
  final String willStream;

  // ID of the opponent
  final String opponentId;


  @override
  _ConfirmNewGameState createState() => _ConfirmNewGameState();
}

class _ConfirmNewGameState extends State<ConfirmNewGame> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]); // fix the orientation up for this game interface

    // Ask to be notified when a message from the server comes in.
    game.addListener(_onAction);

  }

  @override
  void dispose() {
    game.removeListener(_onAction);
    super.dispose();
  }


  _onAction(message) {  }

  _getOpponentName(){
    return widget.opponentName;
  }

  _getStream(){
    if(widget.willStream == "Yes") return ("The game will be Streamed");
    if(widget.willStream == "No") return ("The Game will not be Streamed");
    return ("Somthing is wrong");
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              height: size.height * 0.2,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(_getOpponentName()+ "Invites You To a New Game & " + _getStream(),
                style: TextStyle(
                  fontFamily: "Acme",
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                  ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConfirmButton(
                      text: "REJECT",
                      press: () { 
                        // if the player does not want to play pop the screen and notify the invitor
                        Navigator.pop(context);
                        game.send("exit_game", widget.opponentId);
                      },
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ConfirmButton(
                      text: "PLAY",
                      press: () {
                        // remove new game confirm screen
                        Navigator.pop(context);
                        // if the player wants to play direct him to the game screen
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context)
                          => new PlayGame(
                            opponentName: widget.opponentName, // Name of the opponent
                            opponentId: widget.opponentId, // Id of the opponent
                            character: 'b',
                        ),
                        )); 
                       },
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              
              ],)
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
          ],
        ),
      ),
    );
  }
 
}
