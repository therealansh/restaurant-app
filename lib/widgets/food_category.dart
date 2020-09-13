import 'package:flutter/material.dart';

//navigation thru different category
class FoodCategory extends StatelessWidget {
  final String category;
  final bool active;
  FoodCategory({this.active = false, this.category});

  Widget build(context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 30),
      child: Text(
        category,
        style: TextStyle(
            color: active ? Color(0xFFFB475F) : Colors.black.withOpacity(0.4),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
