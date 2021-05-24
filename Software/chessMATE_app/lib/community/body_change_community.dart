import 'package:chessMATE_app/community/community_data.dart';
import 'package:chessMATE_app/screens/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';

class ChangeCommunityBody extends StatefulWidget {
  const ChangeCommunityBody({
    Key key,
  }) : super(key: key);

  @override
  _ChangeCommunityBodyState createState() => _ChangeCommunityBodyState();
}

class _ChangeCommunityBodyState extends State<ChangeCommunityBody> {

  List listOfCommunities = [];

  @override
  void initState(){
    super.initState();
    // Ask to be notified when messages related to the game are sent by the server
    game.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  _onGameDataReceived(message) {
    switch (message["action"]) {

      case 'communities_list':
        listOfCommunities = message["data"];
        // force rebuild
        setState(() {});
        print(listOfCommunities);
      break;

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: size.height * 0.2,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text("SELECT A COMMUNITY", 
              style: TextStyle(
                color: Colors.white, 
                fontSize: 25, 
                fontFamily: "Acme", 
                fontWeight: FontWeight.bold
              ), 
              ),
              Column(
                  children: listOfCommunities.map((community) {  
                    return communityDetailCard( community["name"],community["no_of_members"]);
              }).toList()),
              
              
            ],
          ),
        ) ,
        ),
    );
  }

  Widget communityDetailCard( String name, int noOfMembers) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        splashColor: Colors.red,
        onTap: () {
          Navigator.of(context).pop(true);
          Navigator.pushNamed(context, CommunityScreen.id);
          List <String> dataChangeComm = [name, get_Community()];
          game.send('change_community', dataChangeComm.join(':'));
          set_Community(name);  
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
                              image: AssetImage('assets/group.png')))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name ,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Acme",
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "No. Of Members: " +"$noOfMembers" ,
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
}