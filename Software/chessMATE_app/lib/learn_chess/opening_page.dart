import 'dart:async';

import 'package:chessMATE_app/learn_chess/chess_board.dart';
import 'package:chessMATE_app/data/opening_data.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/learn_chess/opening_detail.dart';

class OpeningsPage extends StatefulWidget {
static const String id = 'OpeningsPage';
  const OpeningsPage({
    Key key,
  }) : super(key: key);

  @override
  _OpeningsPageState createState() => _OpeningsPageState();
}

class _OpeningsPageState extends State<OpeningsPage> {

  List<ChessBoardController> controllers = [];

  @override
  void initState() {
    super.initState();
    for(int i = 0; i<openings.length; i++) {
      controllers.add(ChessBoardController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 3),
      body: ListView.builder(
          itemCount: openings.length,
          itemBuilder: (context,position) {
          return OpeningCard(
            leftWidget: ChessBoard(
              onMove: (move){},
              onDraw: (){},
              onCheckMate: (win){},
              chessBoardController: controllers[position],
              initMoves: openings[position].moves,
              enableUserMoves: false,
            ),
            rightWidget: Center(
              child: Text(
                openings[position].name,
                style: TextStyle(
                  fontSize: 17, 
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                  ),
                ),
            ),
            heroTag: "Opening$position",
            onTap: (){
              Navigator.push(
                context,
                MyCustomRoute(
                  builder: (context) => OpeningDetailPage(
                    position: position,
                  ),
                ),
              );
            },
          );
      },),
    );
  }
}

class OpeningCard extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final GestureTapCallback onTap;
  final String heroTag;

  OpeningCard({this.leftWidget, this.rightWidget, this.onTap, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 4.0,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Material(
                      child: Hero(
                        child: leftWidget,
                        tag: heroTag,
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: rightWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
      return child;
  
  }
}

