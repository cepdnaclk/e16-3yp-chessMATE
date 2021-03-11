
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const ConfirmButton({
    Key key,
    this.text,
    this.press,
    this.color,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      width: size.width * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "Acme",
              letterSpacing: 5,
            ),
          ),
        ),
      ),
    );
  }
}