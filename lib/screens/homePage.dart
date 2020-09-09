import 'package:flutter/material.dart';
import 'package:restaurant_app/services/authService.dart';

class HomePage extends StatefulWidget{
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  Widget build(context){
    return WillPopScope(
    onWillPop: () async => false,
      child:  Scaffold(
        body: RaisedButton(
        onPressed: (){AuthService().logout();},
    child: Center(child:Text("Logout"))
    ),)
    );
  }
}