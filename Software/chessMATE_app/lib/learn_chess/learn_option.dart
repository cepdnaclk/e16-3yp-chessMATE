import 'package:chessMATE_app/learn_chess/piece_list.dart';
import 'package:chessMATE_app/options/option_button.dart';
import 'package:flutter/material.dart';

import 'opening_page.dart';

class LearnOptions extends StatelessWidget {
  const LearnOptions({
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
              text: "LEARN ABOUT PICES",
              press: () {
                Navigator.pushNamed(context, PiecesPage.id);
              },
              
              color: Colors.lightBlue[300],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            OptionButton(
              text: "CHESS OPENINGS",
              press: () {
                Navigator.pushNamed(context, OpeningsPage.id);
              },
              color: Colors.lightBlue[700],
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
