import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final icon;
  const OptionButton({
    Key key,
    this.text,
    this.press,
    this.color,
    this.textColor = Colors.white,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: size.width * 0.8,
      height: size.height * 0.1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              Icon(icon,color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }
}