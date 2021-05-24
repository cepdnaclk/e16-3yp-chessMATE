
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/screens/option_screen.dart';
import 'package:flutter/material.dart';

class DisplayWinner extends StatefulWidget {
  DisplayWinner({
    Key key,
    this.name,
  }) : super(key: key);

  // Name of the game
  final String name;

  @override
  _DisplayWinnerState createState() => _DisplayWinnerState();
}

class _DisplayWinnerState extends State<DisplayWinner> {
 
 @override
 Widget build(BuildContext context) {
   Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(4, 7, 40, 3),
        body: SafeArea(
          child: ListView(children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(
                      "assets/logo.png",
                      height: size.height * 0.2,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                  Text(getText(widget.name),
                  style: TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 7,
                  ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.pushNamed(context, OptionScreen.id);
                    },
                    child: Text("OK",style: TextStyle(
                      fontFamily: 'Acme',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
 }

  String getText(name) {
    String text = (name == " ") ? "GAME DRAW" : "GAME WON BY $name" ;
    return text;
  }
}
