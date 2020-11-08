import 'package:chessMATE_app/options/option_button.dart';
import 'package:chessMATE_app/screens/playerDetails_screen.dart';
import 'package:flutter/material.dart';


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
            Text(
              "chessMATE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.grey.withOpacity(0.8),
                fontFamily: "Audiowide",
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),

            OptionButton(
              text: "PLAY WITH A FRIEND",
              press: () {
                Navigator.pushNamed(context, PlayerDataScreen.id);
              },
              color: Colors.lightBlue[300],
              icon: Icons.person,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            OptionButton(
              text: "PLAY WITH AI",
              press: () {},
              color: Colors.lightBlue[500],
              icon: Icons.computer,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            OptionButton(
              text: "LEARN CHESS",
              press: () {},
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