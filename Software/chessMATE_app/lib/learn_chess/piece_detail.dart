import 'dart:async';
import 'package:chessMATE_app/chessGame/chess_board.dart';
import 'package:chessMATE_app/data/piece_data.dart';
import 'package:flutter/material.dart';

class PieceDetailPage extends StatefulWidget {
  final int position;

  PieceDetailPage({@required this.position});

  @override
  _PieceDetailPageState createState() => _PieceDetailPageState();
}

class _PieceDetailPageState extends State<PieceDetailPage> {
  ChessBoardController controller = new ChessBoardController();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      controller.clearBoard();
      controller.putPiece(
          pieces[widget.position].pieceType, "e2", PieceColor.White);
      controller.putPiece(
          pieces[widget.position].pieceType, "e7", PieceColor.Black);
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 3),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _buildTitle(),
            _buildContent(),
            _buildChessBoard(MediaQuery.of(context).size),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Hero(
              tag: "Piece${widget.position}",
              child: pieces[widget.position].pieceWidget),
        ),
        Text(
          pieces[widget.position].name,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
      child: Text(
        pieces[widget.position].information,
        style: TextStyle(fontSize: 20.0,color: Colors.white,),
      ),
    );
  }

  Widget _buildChessBoard(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ChessBoard(
        size: size.width,
        onDraw: () {},
        onCheckMate: (winColor) {},
        onMove: (moveNotation, from, to) {},
        chessBoardController: controller,
      ),
    );
  }
}
