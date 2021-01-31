import 'package:chessMATE_app/learn_chess/opening_page.dart';
import 'package:chessMATE_app/learn_chess/piece_list.dart';
import 'package:chessMATE_app/screens/learn_screen.dart';
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
import 'package:chessMATE_app/backEnd_conn/websockets.dart';

import 'screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Let's initialize the WebSockets communication
    sockets.initCommunication();
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
        LearnScreen.id: (context) => LearnScreen(),
        PiecesPage.id: (context) => PiecesPage(),
        OpeningsPage.id: (context) => OpeningsPage(),
      },
    );
  }
}

