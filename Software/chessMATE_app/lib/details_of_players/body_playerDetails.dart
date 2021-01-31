// import 'package:chessMATE_app/screens/gameScreen.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';
import 'package:chessMATE_app/chessGame/buildGame.dart';

const String profile_Img = 'assets/player.png';

class Player {
  final String profileImg;
  final String username;
  // final String rating_level;
  // final String age;

  Player({this.profileImg, this.username});
}

class PlayerDataBody extends StatefulWidget {
  @override
  _PlayerDataBodyState createState() => _PlayerDataBodyState();
}

class _PlayerDataBodyState extends State<PlayerDataBody> {
  String playerName;
  List<dynamic> playersList = <dynamic>[];

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
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _onGameDataReceived(message) {
    switch (message["action"]) {

      // Each time a new player joins, we need to
      //   * record the new list of players
      //   * rebuild the list of all the players
      case 'players_list':
        playersList = message["data"];
        // force rebuild
        setState(() {});
        break;

      ///
      /// When a game is launched by another player, we accept the new game and automatically redirect to the game board.
      /// As we are not the new game initiator, we will be playing "black" (temp)
      ///
      case 'new_game':
        Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)
                      => new PlayGame(
                            opponentName: message["data"], // Name of the opponent
                            character: 'b',
                        ),
        ));
        break;
    }
  }


  Widget personDetailCard(Player, String id) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        splashColor: Colors.red,
        onTap: () {
          _onPlayGame(Player.username, id);
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(Player.profileImg)))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Player.username,
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
              ],
            ), 
          ),
        ),
      ),
    );
  }

  _onPlayGame(String opponentName, String opponentId){
    // We need to send the opponentId to initiate a new game
    game.send('new_game', opponentId);
	
    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) 
                  => new PlayGame(
                      opponentName: opponentName, 
                      character: 'w',
                    ),
    ));
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
                    "FIND PLAYERS",
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
                  children: playersList.map((playerInfo) {
                    Player player = new Player(profileImg: profile_Img,username: playerInfo["name"] );
                return personDetailCard(player, playerInfo["id"]);
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
