import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/confirm_password_field.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_input_field.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_password_field.dart';
import 'package:chessMATE_app/screens/loginScreen.dart';
import 'package:flutter/material.dart';


class BodyForgotPass extends StatelessWidget {
  const BodyForgotPass({
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
              Text(
                "chessMATE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: "Audiowide",
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "RESET PASSWORD",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: "Acme",
                  letterSpacing: 5,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              RoudedInputField(
                hintText: "Email",
                onChanged: (value) {},
                icon: Icons.email,
              ),
              RoundedPasswordField(
                onChanged: (value) {},
                text: "New Password",
              ),
              ConfirmPasswordField(
                onChanged: (value) {},
                text: "Confirm New Password",
              ),
              RoundedButton(
                text: "RESET",
                press: () {
                  Navigator.pushNamed(context, LoginScreen.id);
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
