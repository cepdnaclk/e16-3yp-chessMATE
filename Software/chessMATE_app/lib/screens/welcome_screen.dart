import 'package:chessMATE_app/welcome/body_welcome.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'WelcomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: WelcomeBody(),
    );
  }
}
