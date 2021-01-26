import 'package:chessMATE_app/signIn/body_signIn.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  static const String id = 'SignInScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: BodySignIn(),
    );
  }
}
