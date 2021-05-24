import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/community/community_data.dart';
import 'package:chessMATE_app/screens/change_community.dart';
import 'package:chessMATE_app/screens/community_screen.dart';
import 'package:chessMATE_app/screens/create_community.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/backEnd_conn/game_communication.dart';

class CommunityBody extends StatefulWidget {
  const CommunityBody({
    Key key,
  }) : super(key: key);

  @override
  _CommunityBodyState createState() => _CommunityBodyState();
}

class _CommunityBodyState extends State<CommunityBody> {

  List titleOfPage = ["YOU ARE NOT IN A COMMUNITY", "YOU ARE IN " + get_Community() +" COMMUNITY"];
  List button1Text = ["Join to a New Community" , "Change Community"];
  List button2Text = ["Continue Without Joining", "Stay In Community"];
  int textNumber = (get_Community() == "**") ? 0 : 1 ;

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
            height: size.height * 0.02,
          ),
          Text(titleOfPage[textNumber], 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 25, 
            fontFamily: "Acme", 
            fontWeight: FontWeight.bold
          ), 
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          RoundedButton(
            text: button1Text[textNumber],
            press: (){
              // user want change the community or join to a community
              Navigator.of(context).pop(true);
              game.send("request_community_list", get_Community());
              Navigator.pushNamed(context, ChangeCommunity.id); 
            },
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          RoundedButton(
            // user do not want to change the community
            text: button2Text[textNumber],
            press: (){
              Navigator.pushNamed(context, GameModeScreen.id);
            },
          ),
          
          get_Leave_Button(textNumber, size), // only for users who alredy in a community
         
          RoundedButton(
            // create new community
            text: "Create New Community",
            press: (){
              Navigator.pushNamed(context, CreateCommunityScreen.id);
            },
          ),
        ],
      ),
    ) ,
    ),
      );
  }

  // ignore: non_constant_identifier_names
  Widget get_Leave_Button(int textNumber, Size size) {
    if(textNumber == 1){
      return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
                height: size.height * 0.02,
              ),
           RoundedButton(
                // Exit from the community
                text: "Leave Community",
                press: (){
                  // user will be put into default community
                  
                  game.send('leave_community', get_Community());
                  Navigator.pushNamed(context, CommunityScreen.id);
                  set_Community("**");
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
        ],
      ),
    );
    }

    return SizedBox(
                height: size.height * 0.02,
              );
    
  }

}