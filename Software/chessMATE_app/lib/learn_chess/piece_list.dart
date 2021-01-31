import 'package:chessMATE_app/data/piece_data.dart';
import 'package:chessMATE_app/learn_chess/piece_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PiecesPage extends StatefulWidget {
  static const String id = 'PiecePage';
  const PiecesPage({
    Key key,
  }) : super(key: key);

  @override
  _PiecesPageState createState() => _PiecesPageState();
}

class _PiecesPageState extends State<PiecesPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 3),
      body: Center(
        child: ListView.builder(
          itemCount: pieces.length,
          itemBuilder: (context, position) {
            String name = pieces[position].name;
            Widget widget = pieces[position].pieceWidget;

            return PieceCard(
              leftWidget: widget,
              rightWidget: Text(
                name,
                style: TextStyle(fontSize: 16.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MyCustomRoute(
                    builder: (context) => PieceDetailPage(
                          position: position,
                        ),
                  ),
                );
              },
              heroTag: "Piece$position",
            );
          },
        ),
      ),
    );
  }
}

class PieceCard extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final GestureTapCallback onTap;
  final String heroTag;

  PieceCard({this.leftWidget, this.rightWidget, this.onTap, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color:Colors.lightBlue[300],
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
                  flex: 1,
                  child: Center(
                    child: Material(
                      child: Hero(
                        child: leftWidget,
                        tag: heroTag,
                      ),
                      color: Colors.lightBlue[300],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
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
