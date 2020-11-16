import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/confirm_password_field.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_input_field.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_password_field.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:flutter/material.dart';

class BodySignIn extends StatelessWidget {
  const BodySignIn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: size.height * 0.2,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                "SIGN IN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontFamily: "Acme",
                  letterSpacing: 5,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              RoudedInputField(
                hintText: "Username",
                onChanged: (value) {},
                icon: Icons.person,
              ),
              RoudedInputField(
                hintText: "Email",
                onChanged: (value) {},
                icon: Icons.email,
              ),
              RoundedPasswordField(
                onChanged: (value) {},
                text: "Password",
              ),
              ConfirmPasswordField(
                onChanged: (value) {},
                text: "Confirm Password",
              ),
              RoudedInputField(
                hintText: "Date of Birth",
                onChanged: (value) {},
                icon: Icons.calendar_today,
              ),
              RoundedButton(
                text: "Create Account",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameModeScreen()));
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
