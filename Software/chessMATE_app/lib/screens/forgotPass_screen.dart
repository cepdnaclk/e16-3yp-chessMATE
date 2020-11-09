import 'package:chessMATE_app/forgot_password/body_forgotPass.dart';
import 'package:flutter/material.dart';



class ForgotPassScreen extends StatelessWidget {

  static const String id = 'ForgotPassScreen';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BodyForgotPass(),
    );
  }
}
