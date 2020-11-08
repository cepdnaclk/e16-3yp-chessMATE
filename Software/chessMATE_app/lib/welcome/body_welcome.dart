import 'package:chessMATE_app/screens/loginScreen.dart';
import 'package:chessMATE_app/welcome/welcome_button.dart';
import 'package:flutter/material.dart';




class WelcomeBody extends StatelessWidget {
  const WelcomeBody({
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
                fontSize: 38,
                fontFamily: "Audiowide",
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              "Smart Chess Platform",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: "Acme",
                letterSpacing: 5,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            WelcomeButton(
              text: "PLAY",
              press: () {
                Navigator
                .push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()
                    )
                );
              },
              color: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }
}