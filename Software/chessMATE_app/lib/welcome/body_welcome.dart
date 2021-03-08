import 'package:chessMATE_app/screens/loginScreen.dart';
import 'package:chessMATE_app/welcome/welcome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
          // ignore: missing_return
          onWillPop: () { 
            SystemNavigator.pop();
           },
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/chessMATElogo.png"),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.5,
              ),
              Text(
                "Smart Chess Platform",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: "Acme",
                  letterSpacing: 5,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              WelcomeButton(
                text: "PLAY",
                press: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                color: Colors.lightBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
