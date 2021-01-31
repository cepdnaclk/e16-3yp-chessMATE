import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_input_field.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_password_field.dart';
import 'package:chessMATE_app/login/already_have_an_account_check.dart';
import 'package:chessMATE_app/screens/forgotPass_screen.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:chessMATE_app/screens/signInScreen.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';
import 'package:chessMATE_app/backEnd_conn/websockets.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();

}


class _LoginPageState extends State<LoginPage>{

  // static final TextEditingController _name = new TextEditingController();
  static String _userName;
  static String _password;
  String playerName;
  List<dynamic> playersList = <dynamic>[];

  
  @override
  void initState() {
    super.initState();
    // Ask to be notified when messages related to the game are sent by the server
    // game.addListener();
  }

  @override
  void dispose() {
    // game.removeListener(_onGameDataReceived);
    super.dispose();
  }

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
                height: size.height * 0.05,
              ),
              Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: "Acme",
                  letterSpacing: 7,
                ),
              ),
              Container(
                child: sockets.socketStatus()?null:Text("Server not connected",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.red
                  ),
                )
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              RoudedInputField(
                hintText: "Username",
                onChanged: (value) {
                  _userName = value;
                },
                icon: Icons.email,
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  _password = value;
                },
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
                press: sockets.socketStatus()? ()=>{
                  game.send('join', _userName),
                  Navigator.pushNamed(context, GameModeScreen.id)
                }:null,
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
