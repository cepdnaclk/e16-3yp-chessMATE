import 'package:chessMATE_app/backEnd_conn/game_communication.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_input_field.dart';
import 'package:chessMATE_app/buttons_login-signIn-forgotPassword/rounded_password_field.dart';
import 'package:chessMATE_app/login/already_have_an_account_check.dart';
import 'package:chessMATE_app/screens/forgotPass_screen.dart';
import 'package:chessMATE_app/screens/game_mode_screen.dart';
import 'package:chessMATE_app/screens/loginScreen.dart';
import 'package:chessMATE_app/screens/signInScreen.dart';
import 'package:chessMATE_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:chessMATE_app/backEnd_conn/websockets.dart';
import 'handle_google_sign_in.dart';
import 'login_validate.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes:[
    'profile',
    'email'
  ]
);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List topics = [
    "Invalid email",
    "Invalid password",
    "Invalid email & password"
  ];
  List msgs = [
    "Enter a valid email",
    "Enter a valid password",
    "Enter valid email & password"
  ];
  static int isValid;
  // static final TextEditingController _name = new TextEditingController();
  static String _userName;
  static String _password;
  String playerName;
  List<dynamic> playersList = <dynamic>[];
  bool userCorrect;
  String userError = "";
  List<String> dataMsgLogin = <String>[];
  GoogleSignInAccount _currentUser;


  @override
  void initState() {
    super.initState();
    // Ask to be notified when messages related to the game are sent by the server
    game.addListener(_onGameDataReceived);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) { 
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  _onGameDataReceived(message) {
    switch (message["action"]) {

      // Each time a new player joins, we need to
      //   * record the new list of players
      //   * rebuild the list of all the players

      case 'userValidity':
        userCorrect = message["data"];
        if (userCorrect == false) {
          // force rebuild
          setState(() {
            userError = 'Username or Password is incorrect!!';
          });
        } else {
          Navigator.pushNamed(context, GameModeScreen.id);
        }

        break;

      ///
      /// When a game is launched by another player, we accept the new game and automatically redirect to the game board.
      /// As we are not the new game initiator, we will be playing "black" (temp)
      ///

    }
  }


  // method to handdle press back button
  Future<bool> _onBackPressed() {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?',
      style: TextStyle(color: Colors.white),
      ),
      content: new Text('Do you want to log out?',
      style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.lightBlue[900],
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("NO", style: TextStyle(color: Colors.white),),
        ),
        SizedBox(height: 16),
        new FlatButton(
          onPressed: () async {
            if(_currentUser != null){
              _googleSignIn.disconnect();
              Navigator.of(context).pop(true);
            // send a message to the server 
            game.send('log_out', "");
            Navigator.pushNamed(context, LoginScreen.id);
            } else {
              Navigator.of(context).pop(true);
            // send a message to the server 
            game.send('log_out', "");
            // direct to the welcomscreen
            Navigator.pushNamed(context, WelcomeScreen.id);
            }
            },
          child: Text("YES", style: TextStyle(color: Colors.white),),
        ),
      ],
    ),
  ) ??
      false;
}


  @override
  Widget build(BuildContext context) {  
    
    if( _currentUser != null){ // user has selected an account, then get the pasword
      set_signIn(_googleSignIn);
      set_currentUser(_currentUser);
      return getPassword(context);
    } else {  // user does not have selected an account, then wait at the login
      return getUser(context);
    }                                                  
  }
                  
  Widget getUser(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
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
                  height: size.height * 0.05,
                ),
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: "Acme",
                    letterSpacing: 7,
                  ),
                ),
                Container(
                    child: sockets.socketStatus()
                        ? null
                        : Text(
                            "Server not connected",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.red),
                          )),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  userError,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: "Acme",
                    letterSpacing: 5,
                    color: Colors.red,
                  ),
                ),
                RoudedInputField(
                  hintText: "Email Address",
                  onChanged: (value) {
                    _userName = value;
                  },
                  icon: Icons.email,
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    _password = value;
                  },
                  text: "Password",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ForgotPassScreen.id);
                      },
                      child: Text(
                        'Forgot Password ? ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.lightBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                RoundedButton(
                  text: "LOGIN",
                  press: sockets.socketStatus()
                      ? () => {
                            isValid = validate_login(_userName, _password),
                            if (isValid == 4)
                              {
                                dataMsgLogin = [_userName, _password],
                                game.send('join', dataMsgLogin.join(':')),
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text(
                                          topics[isValid],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        content: new Text(
                                          msgs[isValid],
                                          style: TextStyle(
                                            color: Colors.white,
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
                                                  fontSize: 15,
                                                ),
                                              ))
                                        ],
                                      );
                                    }),
                              }
                            // game.send('join', _userName),
                            // Navigator.pushNamed(context, GameModeScreen.id)
                          }
                      : null,
                ),
                Text(
                  'Or',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.lightBlue,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: MaterialButton(onPressed:() async{
                        try{
                          _googleSignIn.signIn();
                        } catch (error){
                          print(error);
                        }  
                      },
                      color: Color.fromRGBO(4, 7, 40, 90),
                      textColor: Colors.white,
                      child: Text("G", style: TextStyle(fontSize: 50, color: Colors.indigo[200] ), ),
                      shape: CircleBorder( )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.lightBlue,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: MaterialButton(onPressed:(){},
                      color: Color.fromRGBO(4, 7, 40, 90),
                      textColor: Colors.white,
                      child: Text("f", style: TextStyle(fontSize: 50, color: Colors.indigo[200] ), ),
                      shape: CircleBorder( )
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.pushNamed(context, SignInScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
      
   Widget getPassword(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
       onWillPop: _onBackPressed,
       child: Container(
         child: Center(
           child : SingleChildScrollView(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Image.asset("assets/logo.png",height: size.height * 0.2,
                 ),
                 SizedBox( height: size.height * 0.05,),
                 Text("LOGIN AS", style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: "Acme", letterSpacing: 3),),
                 SizedBox( height: size.height * 0.03,),
                 Text(_currentUser.displayName, style: TextStyle(color: Colors.blue[200], fontSize: 25, fontFamily: "Acme"),),
                 Text(_currentUser.email, style: TextStyle(color: Colors.blue[100], fontSize: 20, fontFamily: "Acme"),),
                 Text(userError,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: "Acme",letterSpacing: 5,color: Colors.red,),),
                 SizedBox( height: size.height * 0.05,),
                 RoundedPasswordField(
                  onChanged: (value) {
                    _password = value;
                  },
                  text: "Password",
                  ),
                  SizedBox( height: size.height * 0.05,),
                  RoundedButton(
                  text: "LOGIN",
                  press: sockets.socketStatus()
                      ? () => {
                            isValid = validate_login(_currentUser.email, _password),
                            if (isValid == 4)
                              {
                                dataMsgLogin = [_currentUser.email, _password],
                                game.send('join', dataMsgLogin.join(':')),
                                
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text(
                                          topics[isValid],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        content: new Text(
                                          msgs[isValid],
                                          style: TextStyle(
                                            color: Colors.white,
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
                                                  fontSize: 15,
                                                ),
                                              ))
                                        ],
                                      );
                                    }),
                              }
                            // game.send('join', _userName),
                            // Navigator.pushNamed(context, GameModeScreen.id)
                          }
                      : null,
                ),
                ],
             ),
           ),
         ),
       ),
    );
  }
                  
}
            
           
