
import 'package:chessMATE_app/community/body_create_community.dart';
import 'package:flutter/material.dart';

class CreateCommunityScreen extends StatelessWidget {
  static const String id = 'CreateCommunityScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: CreateCommunityBody(),
    );
  }
}
