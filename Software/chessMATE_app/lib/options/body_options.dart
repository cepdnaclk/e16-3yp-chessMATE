import 'package:chessMATE_app/options/option_button.dart';
import 'package:chessMATE_app/screens/learn_screen.dart';
import 'package:chessMATE_app/screens/playerDetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';

class BodyOptions extends StatelessWidget {
  const BodyOptions({
    Key key,
  }) : super(key: key);

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
            OptionButton(
              text: "PLAY WITH FRIENDS",
              press: () {
                game.send('request_players_list', game.playerID);
                Navigator.pushNamed(context, PlayerDataScreen.id);
              },
              color: Colors.lightBlue[300],
              icon: Icons.person,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            OptionButton(
              text: "LEARN CHESS",
              press: () {
                Navigator.pushNamed(context, LearnScreen.id);
              },
              color: Colors.lightBlue[700],
              icon: Icons.book,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            OptionButton(
              text: "STREAM GAMES",
              press: () {},
              color: Colors.lightBlue[900],
              icon: Icons.video_collection_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
