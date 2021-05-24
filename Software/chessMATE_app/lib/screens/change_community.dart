
import 'package:chessMATE_app/community/body_change_community.dart';
import 'package:flutter/material.dart';

class ChangeCommunity extends StatelessWidget {
  static const String id = 'ChangeCommunity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: ChangeCommunityBody(),
    );
  }
}
