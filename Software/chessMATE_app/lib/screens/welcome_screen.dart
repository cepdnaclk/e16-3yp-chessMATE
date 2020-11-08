import 'package:chessMATE_app/welcome/body_welcome.dart';
import 'package:flutter/material.dart';



class WelcomeScreen extends StatelessWidget {

  static const String id = 'WelcomeScreen';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: WelcomeBody(),
    );
  }
}