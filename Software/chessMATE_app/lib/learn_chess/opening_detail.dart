import 'package:chessMATE_app/learn_chess/chess_board.dart';
import 'package:chessMATE_app/data/opening_data.dart';
import 'package:flutter/material.dart';


class OpeningDetailPage extends StatefulWidget {
  final position;

  OpeningDetailPage({this.position});

  @override
  _OpeningDetailPageState createState() => _OpeningDetailPageState();
}

class _OpeningDetailPageState extends State<OpeningDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 3),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 5.0,),
          Center(child: Text(openings[widget.position].name,style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)),
          SizedBox(height: 5.0,),
          Hero(
            child: ChessBoard(
              size: MediaQuery.of(context).size.width,
              onMove: (move) {},
              onCheckMate: (win) {},
              onDraw: () {},
              initMoves: openings[widget.position].moves,
            ),
            tag: "Opening${widget.position}",
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              openings[widget.position].moveNotation,
              style: TextStyle(fontSize: 18.0,  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(openings[widget.position].information, style: TextStyle(fontSize: 16.0, color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
