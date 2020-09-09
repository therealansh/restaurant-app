import 'package:flutter/material.dart';
import 'package:restaurant_app/screens/phone_auth_screen.dart';
import 'package:restaurant_app/services/authService.dart';
import 'package:restaurant_app/widgets/round_button.dart';

class SignIn extends StatefulWidget {

  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  Widget build(context){
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.fill
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 34,color: Color(0xFF1D150B)),
                  children: [
                    TextSpan(
                        text: "pizza",
                        style: TextStyle(fontStyle: FontStyle.italic)
                    ),
                    TextSpan(
                        text: "GO",
                        style: TextStyle(color:Color(0xFFff9eb6) )
                    )
                  ]
              ),
            ),
            RoundedButton(text: "Start Ordering",onClick: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));},)
          ],
        ),
      ),
    );
  }
}
