import 'package:chessMATE_app/details_of_players/body_playerDetails.dart';
import 'package:flutter/material.dart';

class PlayerDataScreen extends StatelessWidget {
  static const String id = 'PlayerDataScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: PlayerDataBody(),
    );
  }
}
