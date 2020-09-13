import 'package:flutter/material.dart';
import 'package:restaurant_app/models/food.dart';

//Card Widget for Displaying food items
class FoodCard extends StatelessWidget {
  final Food food;
  final Function onTap;

  FoodCard({
    this.food,
    this.onTap,
  });

  Widget build(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        height: 400,
        width: 270,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 380,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFff9eb6)),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.4)),
              ),
            ),
            Positioned(
              top: 0,
              left: -50,
              child: Container(
                height: 185,
                width: 275,
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(food.imageURL))),
              ),
            ),
            Positioned(
              right: 20,
              top: 80,
              child: Text(
                "₹${food.price}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 40,
              child: Container(
                width: 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      food.toppings,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
