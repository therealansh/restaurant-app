import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/screens/homePage.dart';
import 'package:restaurant_app/services/authService.dart';
import 'package:restaurant_app/widgets/round_button.dart';

class UserProfile extends StatefulWidget {
  UserModel user;
  UserProfile({this.user});
  _UserProfile createState() => _UserProfile();
}

//Edit User Profile Page
class _UserProfile extends State<UserProfile> {
  void initState() {
    super.initState();
  }

  String name;
  String address;

  updateUser() async {
    final res = await http.post(
      "http://localhost:8080/users/${widget.user.uid}",
      body: jsonEncode({"name": name, "address": address}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res.statusCode == 200) {
      print("done");
    } else {
      throw Exception("Failed");
    }
  }

  Widget build(context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                child: Icon(
                  Icons.account_circle,
                  size: 250,
                  color: Theme.of(context).primaryColor,
                ),
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(
                    0xFFff9eb6,
                  ),
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: 10,
                  child: Card(
                      shape: CircleBorder(),
                      elevation: 10,
                      child: CircleAvatar(
                        child: Text(
                          "🍕",
                          style: TextStyle(
                            fontSize: 35,
                          ),
                        ),
                        radius: 30,
                        backgroundColor: Colors.white,
                      )))
            ],
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: TextFormField(
                initialValue: widget.user.name == null ? "" : widget.user.name,
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red)),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                initialValue: widget.user.phone.toString(),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Phone",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red)),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextFormField(
                initialValue:
                    widget.user.address == null ? "" : widget.user.address,
                onChanged: (val) {
                  setState(() {
                    address = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Address",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red)),
                ),
              )),
          RoundedButton(
            text: "Update",
            onClick: () async {
              await updateUser().then((val) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthService().handleAuth()));
              });
            },
          )
        ],
      ),
    );
  }
}
