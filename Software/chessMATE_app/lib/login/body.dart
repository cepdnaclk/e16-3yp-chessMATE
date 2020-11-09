import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_input_field.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_password_field.dart';
import 'package:chessMATE_app/login/already_have_an_account_check.dart';
import 'package:chessMATE_app/screens/forgotPass_screen.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:chessMATE_app/screens/signInScreen.dart';
import 'package:flutter/material.dart';


class Body extends StatelessWidget {
  const Body({
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
                  color: Colors.grey.withOpacity(0.5),
                  fontFamily: "Audiowide",
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  color: Colors.black,
                  fontFamily: "Acme",
                  letterSpacing: 7,
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),

              RoudedInputField(
                hintText: "Email Address",
                onChanged: (value) {},
                icon: Icons.email,
              ),
              RoundedPasswordField(
                onChanged: (value) {},
                text: "Password",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ForgotPassScreen.id);
                    },
                    child: Text(
                      'Forgot Password ? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Colors.lightBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              RoundedButton(
                text: "LOGIN",
                press: () {
                  Navigator.pushNamed(context, GameModeScreen.id);
                },
              ),
              Text(
                'Or',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.lightBlue,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/google.png',
                      height: size.height * 0.1,
                      width: size.width * 0.08,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.lightBlue,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/facebook.png',
                      height: size.height * 0.1,
                      width: size.width * 0.08,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.height * 0.03,
              ),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.pushNamed(context, SignInScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}








