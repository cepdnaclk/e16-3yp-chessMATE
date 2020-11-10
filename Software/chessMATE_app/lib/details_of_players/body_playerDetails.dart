import 'package:chessMATE_app/screens/gameScreen.dart';
import 'package:flutter/material.dart';

class Player{
  final String profileImg;
  final String username;
  final String rating_level;
  final String age;

  Player({this.profileImg,this.username, this.rating_level, this.age});

}

class PlayerDataBody extends StatefulWidget {
  @override
  _PlayerDataBodyState createState() => _PlayerDataBodyState();
}


class _PlayerDataBodyState extends State<PlayerDataBody>  {


  List<Player> players = [
    Player(profileImg: 'assets/player.png', username: 'chessMaster',rating_level: "1",age: "25"),
    Player(profileImg: 'assets/player.png', username: 'queen543',rating_level: "2",age: "33"),
    Player(profileImg: 'assets/player.png', username: 'knight_78',rating_level: "3",age: "19"),
    Player(profileImg: 'assets/player.png', username: 'chessKing',rating_level: "4",age: "30"),
    Player(profileImg: 'assets/player.png', username: 'pawnMaster',rating_level: "5",age: "28"),
    Player(profileImg: 'assets/player.png', username: 'chessDragon',rating_level: "6",age: "20"),
    Player(profileImg: 'assets/player.png', username: 'fighter44',rating_level: "7",age: "33"),
    Player(profileImg: 'assets/player.png', username: 'chessRuler',rating_level: "8",age: "40")
  ];

  Widget personDetailCard(Player) {

    return Padding(
        padding: const EdgeInsets.all(4),

        child: InkWell(
          splashColor: Colors.red,
          onTap: (){
            Navigator.pushNamed(context, GameScreen.id);
          },
          child: Card(
            elevation: 20,
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.blue, width: 3.0),
                  borderRadius: BorderRadius.circular(0)
              ),


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
                                    image: AssetImage(Player.profileImg)
                                )
                            )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(Player.username,
                            style: TextStyle (
                                color: Colors.black,
                                fontSize: 20,
                              fontFamily: "SyneTactile",
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text("Rating Level: ",
                                style: TextStyle (
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Acme",
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(Player.rating_level,
                                style: TextStyle (
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Acme",
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Age: ",
                                style: TextStyle (
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Acme",
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(Player.age,
                                style: TextStyle (
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Acme",
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                    Text(
                      "chessMATE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.5),
                        fontFamily: "Audiowide",
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Text(
                      "FIND PLAYERS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                        fontFamily: "Acme",
                        letterSpacing: 7,
                      ),
                    ),
                  ],
                ),
                  Column(
                    
                      children: players.map((p) {
                        return personDetailCard(p);
                      }).toList()
                  ),

              ],
            ),
          ),

      ),
    );
  }
}