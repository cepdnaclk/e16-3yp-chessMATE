import 'package:flutter/material.dart';
import 'package:chessMATE_app/screens/gameScreen.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:chessMATE_app/screens/playerDetails_screen.dart';
import 'package:chessMATE_app/screens/option_screen.dart';
import 'package:chessMATE_app/screens/results_screen.dart';
import 'package:chessMATE_app/screens/welcome_screen.dart';
import 'package:chessMATE_app/screens/forgotPass_screen.dart';
import 'package:chessMATE_app/screens/loginScreen.dart';
import 'package:chessMATE_app/screens/signInScreen.dart';

import 'screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      initialRoute: WelcomeScreen.id,
      
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ForgotPassScreen.id: (context) => ForgotPassScreen(),
        GameScreen.id: (context) => GameScreen(),
        OptionScreen.id: (context) => OptionScreen(),
        GameModeScreen.id: (context) => GameModeScreen(),
        ResultsScreen.id: (context) => ResultsScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        PlayerDataScreen.id: (context) => PlayerDataScreen(),
      },
    );
  }
}

