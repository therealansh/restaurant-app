import 'dart:convert';
import 'dart:math';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:restaurant_app/models/food.dart';
import 'package:restaurant_app/screens/checkout.dart';
import 'package:restaurant_app/screens/detailPage.dart';
import 'package:restaurant_app/screens/orders.dart';
import 'package:restaurant_app/screens/userProfile.dart';
import 'package:restaurant_app/services/authService.dart';
import 'package:restaurant_app/widgets/food_card.dart';
import 'package:restaurant_app/widgets/food_category.dart';
import 'package:restaurant_app/models/user.dart';

class HomePage extends StatefulWidget {
  final int phone;
  HomePage({this.phone});
  _HomePage createState() => _HomePage();
}

//Random tag line on homepage
List<String> tagline = [
  "Do Good.Be Nice.Order Pizza.Repeat",
  "Pizza.Circle of Life",
  "You can't buy happiness.But you can buy a pizza",
  "A friend in need is pizza indeed"
];

class _HomePage extends State<HomePage> {
  List<FoodCard> foodList = [];
  User user;
  GlobalKey<ScaffoldState> _scaffkey = GlobalKey<ScaffoldState>();

  getFood() async {
    final res = await http.get('http://localhost:8080/products/');
    if (res.statusCode == 200) {
      List<FoodCard> foodItems = (json.decode(res.body) as List)
          .map((e) => FoodCard(
                food: Food.fromJSON(e),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(food: Food.fromJSON(e))));
                },
              ))
          .toList();
      return foodItems;
    } else {
      throw Exception('Failed to load');
    }
  }

  UserModel currentUser;

  //Check if user exists
  Future<bool> userExists() async {
    String uid = await FirebaseAuth.instance.currentUser.uid;
    final res = await http.get("http://localhost:8080/users/${uid}");
    if (res.statusCode == 200) {
      if (json.decode(res.body).length != 0) {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  Future userFetch;
  Future foodFetch;

  //get current user or create a user if doesnt exist
  getUser() async {
    String uid = await FirebaseAuth.instance.currentUser.uid;
    final res = await http.get("http://localhost:8080/users/${uid}");
    if (res.statusCode == 200) {
      var parsedJson = json.decode(res.body);
      if (json.decode(res.body).length != 0) {
        UserModel user = UserModel.fromJSON(parsedJson[0]);
        setState(() {
          currentUser = user;
        });
        return currentUser;
      } else {
        final res = await http.post(
          "http://localhost:8080/users/",
          body: jsonEncode(
              {"uid": uid, "name": "", "phone": widget.phone, "address": ""}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        return UserModel(uid: uid, name: "", phone: widget.phone, address: "");
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  void initState() {
    super.initState();
    foodFetch = getFood();
    userFetch = getUser();
  }

  Widget float1() {
    return Container(
      child: FloatingActionButton(
        heroTag: "tag1",
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfile(user: currentUser)));
        },
        tooltip: 'User Profile',
        child: Icon(Icons.account_circle),
      ),
    );
  }

  Widget float2() {
    return Container(
      child: FloatingActionButton(
        heroTag: "tag2",
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          AuthService().logout();
        },
        tooltip: 'Logout',
        child: Icon(Icons.exit_to_app),
      ),
    );
  }

  Widget build(context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder(
            future: userFetch,
            builder: (context, snap) {
              if (!snap.hasData ||
                  snap.connectionState != ConnectionState.done) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snap.connectionState == ConnectionState.done) {
                return Scaffold(
                  key: _scaffkey,
                  endDrawer: Drawer(
                    child: ListView(
                      padding: EdgeInsets.only(top: 0),
                      children: [
                        DrawerHeader(
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 26, color: Color(0xFF1D150B)),
                                  children: [
                                    TextSpan(
                                        text: "pizza",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    TextSpan(
                                        text: "GO",
                                        style:
                                            TextStyle(color: Color(0xFFff9eb6)))
                                  ]),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Checkout()));
                          },
                          title: Text("Cart"),
                          leading: Icon(Icons.add_shopping_cart),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Orders()));
                          },
                          title: Text("Previous Orders"),
                          leading: Icon(Icons.assignment),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text("Contact Us"),
                          leading: Icon(Icons.help),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('About Us'),
                          leading: Icon(Icons.info),
                        ),
                        ListTile(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                          },
                          title: Text('Log Out'),
                          leading: Icon(Icons.exit_to_app),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: AnimatedFloatingActionButton(
                    colorEndAnimation: Colors.red,
                    colorStartAnimation: Color(0xFFff9eb6),
                    animatedIconData: AnimatedIcons.menu_close,
                    fabButtons: [float1(), float2()],
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20, top: 50),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.clear_all),
                            onPressed: () {
                              _scaffkey.currentState.openEndDrawer();
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "Hello ${snap.data.name} ,\n${tagline[Random().nextInt(tagline.length)]}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FoodCategory(
                              category: "All",
                              active: true,
                            ),
                            FoodCategory(
                              category: "Favorites",
                            ),
                            FoodCategory(
                              category: "Veg",
                            ),
                            FoodCategory(
                              category: "Non-Veg",
                            ),
                            FoodCategory(
                              category: "Pasta",
                            ),
                            FoodCategory(
                              category: "Sides",
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      FutureBuilder(
                        future: foodFetch,
                        builder: (context, snap) {
                          if (!snap.hasData &&
                              snap.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            foodList = snap.data;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: foodList,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
