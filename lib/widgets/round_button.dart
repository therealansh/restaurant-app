import 'package:flutter/material.dart';

//General widget for buttons throughout the project
class RoundedButton extends StatelessWidget {
  RoundedButton({this.text, this.onClick});
  final String text;
  final Function onClick;
  Widget build(context) {
    return GestureDetector(
        onTap: onClick,
        child: Container(
          width: 200,
          height: 50,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 16),
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 15),
                    blurRadius: 30,
                    color: Color(0xFF666666).withOpacity(0.11))
              ]),
          child: Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
