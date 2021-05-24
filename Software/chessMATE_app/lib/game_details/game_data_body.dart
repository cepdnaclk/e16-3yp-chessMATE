import 'package:chessMATE_app/backEnd_conn/game_communication.dart';
import 'package:flutter/material.dart';
import 'view_game_body.dart';


const String profile_Img = 'assets/player.png';

class Game {
  final String gameid;
  final String white_player ;
  final String black_player ;

  Game({this.gameid, this.white_player, this.black_player});
}

class GameDataBody extends StatefulWidget {
  @override
  _GameDataBodyState createState() => _GameDataBodyState();
}

class _GameDataBodyState extends State<GameDataBody> {
  List<dynamic> gamesList = <dynamic>[];
  String white;
  String black;

  @override
  void initState() {
    super.initState();
    // Ask to be notified when messages related to the game are sent by the server
    game.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// This routine handles all messages that are sent by the server.
  /// In this page, only the following 2 actions have to be processed
  ///  - game_list
  ///  - view_game
  /// -------------------------------------------------------------------
  _onGameDataReceived(message) {
    switch (message["action"]) {

      case 'match_list':
        gamesList = message["data"];
        // force rebuild
        setState(() {});
        break;

      case 'view_confirmed':
        if(message["data"]){
          Navigator.push(context,new MaterialPageRoute(
            builder: (BuildContext context) => 
            new ViewGameBody(
            name : "WHITE:$white  BLACK:$black ",
            ),
          )
          );
        }
        break;

    }
  
  }

  Widget gameDetailCard(gameFromList) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        splashColor: Colors.red,
        onTap: () {
          // go to view the game
          game.send('request_to_view',gameFromList.gameid );
          white = gameFromList.white_player;
          black = gameFromList.black_player;
         },
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.blue, width: 3.0),
              borderRadius: BorderRadius.circular(0)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 10, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${gameFromList.white_player} VS ${gameFromList.black_player} "  ,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Acme",
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ), 
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    "assets/logo.png",
                    height: size.height * 0.2,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "SELECT A GAME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: "Acme",
                      letterSpacing: 7,
                    ),
                  ),
                ],
              ),
              Column(
                  children: gamesList.map((g) {
                    Game game = new Game(gameid:g["id"], white_player: g["white_player"], black_player: g["black_player"]);
                return gameDetailCard(game);
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
