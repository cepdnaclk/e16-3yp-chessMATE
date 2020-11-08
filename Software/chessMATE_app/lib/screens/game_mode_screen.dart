import 'package:chessMATE_app/game_mode/body_game_mode.dart';
import 'package:flutter/material.dart';



class GameModeScreen extends StatelessWidget {

  static const String id = 'GameModeScreen';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GameModeBody(),
    );
  }
}

