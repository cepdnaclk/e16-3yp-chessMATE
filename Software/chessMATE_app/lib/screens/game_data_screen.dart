import 'package:chessMATE_app/game_details/game_data_body.dart';
import 'package:flutter/material.dart';

class GameDataScreen extends StatelessWidget {
  static const String id = 'GameDataScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: GameDataBody(),
    );
  }
}