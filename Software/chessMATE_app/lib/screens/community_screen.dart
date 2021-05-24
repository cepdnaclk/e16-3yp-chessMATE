
import 'package:chessMATE_app/community/body_community.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  static const String id = 'CommunityScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: CommunityBody(),
    );
  }
}
