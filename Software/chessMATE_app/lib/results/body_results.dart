import 'package:chessMATE_app/results/results_buttons.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:chessMATE_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';


class ResultsBody extends StatefulWidget {
  const ResultsBody({
    Key key,
  }) : super(key: key);

  @override
  _ResultsBodyState createState() => _ResultsBodyState();
}

class _ResultsBodyState extends State<ResultsBody> {

  int won = 0;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "chessMATE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "Audiowide",
                color: Colors.black.withOpacity(0.5),
              ),
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
                    "1",
                    textAlign: TextAlign.center,
                    style: TextStyle(

                      fontWeight: FontWeight.bold,
                      fontSize: 25,
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
                    "$won",
                    textAlign: TextAlign.center,

                    style: TextStyle(

                      fontWeight: FontWeight.bold,
                      fontSize: 25,
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
                  "PLAYER 1",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: "Acme",
                  ),
                ),
                Text(
                  "PLAYER 2",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: "Acme",
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
                    Navigator.pushNamed(context, GameModeScreen.id);
                  },
                  color: Colors.lightBlue[700],
                ),
                ResultButton(
                  text: "Exit",
                  press: () {
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


