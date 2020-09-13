import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  _Orders createState() => _Orders();
}

//previous orders page
class _Orders extends State<Orders> {
  void initState() {
    super.initState();
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🚚Previous Orders"),
      ),
      body: Center(
        child: Text("Wasn't it amazing?"),
      ),
    );
  }
}
