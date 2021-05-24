import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_input_field.dart';
import 'package:chessMATE_app/community/community_data.dart';
import 'package:chessMATE_app/screens/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';

class CreateCommunityBody extends StatefulWidget {
  const CreateCommunityBody({
    Key key,
  }) : super(key: key);

  @override
  _CreateCommunityBodyState createState() => _CreateCommunityBodyState();
}

class _CreateCommunityBodyState extends State<CreateCommunityBody> {
  static String _communityName = " ";
  List <String> dataCreateCom = <String> [];
  List <String> messages = ["Please Enter a Name for Community", "Community Name is Too Long"];
  bool result;
  String error= " " ;

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

      case 'community_name_validity':
        result = message["data"];
        if (result == false) {
          // force rebuild
          setState(() {
            error = 'community name is alredy used';
          });
        } else {
          error = 'SUCESSFULLY CREATED';
          set_Community(_communityName);
          Navigator.pushNamed(context, CommunityScreen.id);
        }
      break;

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
          onWillPop: () async {
             return true;
          },
          child: Container(
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
                  height: size.height * 0.02,
                ),
                Text("CREATE A NEW COMMUNITY", 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 25, 
                  fontFamily: "Acme", 
                  fontWeight: FontWeight.bold
                ), 
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Text("Enter A Name for Community",
                style: TextStyle(
                  color: Colors.blue[200], 
                  fontSize: 20, 
                  fontFamily: "Acme", 
                ), 
                ),
                Text(
                  error,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: "Acme",
                    letterSpacing: 5,
                    color: Colors.red,
                  ),
                ),
                RoudedInputField(
                  hintText: "Community Name",
                  onChanged: (value) {
                    _communityName = value;
                  },
                  icon: Icons.group,
                ),
                Text("Community name can have maximum 15 characters",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 15, 
                  fontFamily: "Acme", 
                ), 
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                RoundedButton(
                  text: "CREATE",
                  press: (){
                    int valid = _validateCommunityName(_communityName);
                    if (valid == 0)
                              {
                                dataCreateCom = [_communityName, get_Community()];
                                game.send('create_community', dataCreateCom.join(':'));
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text(
                                          messages[valid-1],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Acme'
                                          ),
                                        ),
                                        backgroundColor: Colors.lightBlue[900],
                                        actions: <Widget>[
                                          new FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: new Text(
                                                "ok",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: 'Acme'
                                                ),
                                              ))
                                        ],
                                      );
                                    });
                              }
                  },
                )
              ],
            ),
          ) ,
          ),
      ),
    );
  }

  int _validateCommunityName( String name) {
    if(name != null){
      if(name.length <= 15 && name.length>0) return 0 ; // valid
      else return 2;  // invalid --> name is too long
    }
    
    else  return 1; // invalid --> no name entered
    
  }


}