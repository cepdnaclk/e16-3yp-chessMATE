
import 'package:chessMATE_app/options/body_options.dart';
import 'package:flutter/material.dart';


class OptionScreen extends StatelessWidget {

  static const String id = 'OptionScreen';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BodyOptions(),
    );
  }
}

