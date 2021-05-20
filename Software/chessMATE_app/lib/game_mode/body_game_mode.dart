

import 'package:chessMATE_app/bluetooth_conn/bluetoothConn.dart';
import 'package:chessMATE_app/game_mode/game_mode_buttons.dart';
import 'package:chessMATE_app/screens/option_screen.dart';
import 'package:flutter/material.dart';

class GameModeBody extends StatelessWidget {
  const GameModeBody({
    Key key,
  }) : super(key: key,);

  BuildContext get context => null;



  @override
  Widget build(BuildContext context) {
    context = context;
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
          "GAME MODES",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            fontFamily: "Acme",
            letterSpacing: 5,
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
            CircleAvatar(
              child: CircleAvatar(
                child: Image.asset('assets/chessBoard.png'),
                radius: 80.0,
                backgroundColor: Colors.white,
              ),
              radius: 90.0,
              backgroundColor: Colors.orange[800],
            ),
            CircleAvatar(
              child: CircleAvatar(
                child: Image.asset(
                  'assets/mobileApp.png',
                ),
                radius: 80.0,
                backgroundColor: Colors.white,
              ),
              radius: 90.0,
              backgroundColor: Colors.blue[800],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GameModeButton(
              text: "BOARD",
              press: () {
                // Navigator.pushNamed(context, OptionScreen.id);
                Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext context) => new BluetoothPage(),
                ));
              },
              color: Colors.orange[800].withOpacity(0.8),
            ),
            GameModeButton(
              text: "APP",
              press: () {
                Navigator.pushNamed(context, OptionScreen.id);
              },
              color: Colors.lightBlue[800].withOpacity(0.8),
            ),
          ],
        ),
      ],
    ),
                  ),
                );
            }
          
            // method to handdle press back button
  
}
