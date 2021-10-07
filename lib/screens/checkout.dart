import 'package:flutter/material.dart';
import 'package:restaurant_app/bloc/cart_bloc.dart';
import 'package:restaurant_app/screens/detailPage.dart';
import 'package:restaurant_app/widgets/round_button.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class Checkout extends StatefulWidget {
  _Checkout createState() => _Checkout();
}

//Cart
class _Checkout extends State<Checkout> {
  GlobalKey<ScaffoldState> _scaffState = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    print(bloc.allItems['cartItems']); //debug
  }

  //timer for cancelling the order
  bool showTimer = false;

  Widget build(context) {
    return Scaffold(
      key: _scaffState,
      appBar: AppBar(
        title: Text("🍕Cart"),
      ),
      body: StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.allItems,
        builder: (context, AsyncSnapshot<dynamic> snap) {
          var data = snap.data['cartItems'];
          return data.length > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 20),
                                  child: Dismissible(
                                      background: Container(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                            ),
                                            Icon(Icons.delete)
                                          ],
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.delete),
                                          ],
                                        ),
                                      ),
                                      key: Key(data.toString()),
                                      onDismissed: (direction) {
                                        _scaffState.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text("Removed"),
                                        ));
                                        setState(() {
                                          bloc.removeFromCart(
                                            data[index],
                                          );
                                        });
                                      },
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen(
                                                        food: data[index],
                                                      )));
                                        },
                                        title: Text(
                                          data[index].name,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              data[index].imageURL),
                                          radius: 40,
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                        ),
                                        trailing: Text(
                                          "₹${data[index].price}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )));
                            }),
                      ),
                      showTimer //Cancel window opens for 5 mins
                          ? SlideCountdownClock(
                              duration: Duration(minutes: 5),
                              slideDirection: SlideDirection.Down,
                              separator: ":",
                              onDone: () {},
                            )
                          : Container(),
                      showTimer
                          ? RoundedButton(
                              text: "Cancel",
                              onClick: () {
                                setState(() {
                                  showTimer = false;
                                });
                              },
                            )
                          : RoundedButton(
                              text: "Order",
                              onClick: () {
                                setState(() {
                                  showTimer = true;
                                });
                                Future.delayed(Duration(minutes: 30), () {
                                  setState(() {
                                    bloc.clearCart();
                                    showTimer = false;
                                  });
                                });
                              },
                            ),
                      Padding(
                        padding: EdgeInsets.only(top: 80),
                      )
                    ])
              : Center(
                  child: Text("Pizza misses you!"),
                );
        },
      ),
    );
  }
}
