import 'package:chessMATE_app/backEnd_conn/game_communication.dart';
import 'package:chessMATE_app/results/results_buttons.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:chessMATE_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class ResultsBody extends StatefulWidget {
  const ResultsBody({
    Key key,
    this.winner,
    this.loser,
    this.draw,
  }) : super(key: key);

  final String winner;
  final String loser;
  final bool draw;

  @override
  _ResultsBodyState createState() => _ResultsBodyState();
}

class _ResultsBodyState extends State<ResultsBody> {
  List<String> results = [];
    @override
  void initState() {
    super.initState();
    // Ask to be notified when messages related to the game are sent by the server
    game.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  _onGameDataReceived(message){
    
  }

  String _getResults(int index){
    if(widget.draw == false){
      results.add("1");
      results.add("0");
    }

    if(widget.draw == true){
      results.add("D");
      results.add("D");
    }
    return results[index];
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
            Text(
              "RESULTS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                fontFamily: "Acme",
                letterSpacing: 5,
                decoration: TextDecoration.none,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlue[500],
                      width: 6,
                    ),
                  ),
                  child: Text(
                    _getResults(0),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlue[500],
                      width: 6,
                    ),
                  ),
                  child: Text(
                    _getResults(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.winner,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: "Acme",
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.loser,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: "Acme",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ResultButton(
              text: "Add to History",
              press: () {},
              color: Colors.lightBlue[500],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ResultButton(
                  text: "New Game",
                  press: () {
                    game.send('back_to_new_game', "");
                    Navigator.pushNamed(context, GameModeScreen.id);
                  },
                  color: Colors.lightBlue[700],
                ),
                ResultButton(
                  text: "Exit",
                  press: () {
                   game.send('log_out', "");
                  Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  color: Colors.lightBlue[700],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
