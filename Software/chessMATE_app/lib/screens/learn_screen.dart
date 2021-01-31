import 'package:chessMATE_app/learn_chess/learn_option.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  static const String id = 'LearnScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: LearnOptions(),
    );
  }
}
