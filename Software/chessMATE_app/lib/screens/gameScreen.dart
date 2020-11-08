import 'package:flutter/material.dart';
import 'package:chessMATE_app/chessGame/buildGame.dart';

class GameScreen extends StatefulWidget {
  
  static const String id = 'GameScreen'; // id to route to classes
  
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayGame(),
    );
  }
}
