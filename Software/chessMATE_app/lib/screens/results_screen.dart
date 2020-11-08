import 'package:chessMATE_app/results/body_results.dart';
import 'package:flutter/material.dart';



class ResultsScreen extends StatefulWidget {

  static const String id = 'ResultsScreen';

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ResultsBody(),
    );
  }
}