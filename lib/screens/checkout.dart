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
        builder: (context, snap) {
          return snap.data['cartItems'].length > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snap.data['cartItems'].length,
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
                                      key: Key(
                                          snap.data['cartItems'].toString()),
                                      onDismissed: (direction) {
                                        _scaffState.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text("Removed"),
                                        ));
                                        setState(() {
                                          bloc.removeFromCart(
                                              snap.data["cartItems"][index]);
                                        });
                                      },
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen(
                                                        food: snap.data[
                                                            'cartItems'][index],
                                                      )));
                                        },
                                        title: Text(
                                          snap.data['cartItems'][index].name,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(snap
                                              .data['cartItems'][index]
                                              .imageURL),
                                          radius: 40,
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                        ),
                                        trailing: Text(
                                          "₹${snap.data["cartItems"][index].price}",
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
