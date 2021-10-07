import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/services/authService.dart';
import 'package:restaurant_app/widgets/round_button.dart';

int phone;

class PhoneAuth extends StatefulWidget {
  _PhoneAuthState createState() => _PhoneAuthState();
}

//Phone Authentication module
class _PhoneAuthState extends State<PhoneAuth> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  GlobalKey<FormState> _form1 = GlobalKey<FormState>();

  String phoneNumber;
  String code;
  String verificationId;

  bool codeSent = false;

  void initState() {
    super.initState();
  }

  Future phoneAuthentication(phone) async {
    final PhoneVerificationCompleted verified = (AuthCredential auth) {
      AuthService().login(auth);
    };
    final PhoneVerificationFailed verfFailed = (FirebaseAuthException exc) {
      print(exc.message);
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verified,
      verificationFailed: verfFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }

  successAuth() {
    try {
      AuthService().loginWithOTP(code, verificationId);
    } catch (e) {
      print(e.msg);
    }
  }

  Widget build(context) {
    return Scaffold(
        body: FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor,
          ),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 225,
                    child: Text(
                      "Enter Phone Number",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            left: 25.0,
                            right: 25.0,
                          ),
                          child: TextFormField(
                            onChanged: (val) {
                              setState(
                                () {
                                  phoneNumber = "+91" + val;
                                  phone = int.parse(
                                    "+91" + val,
                                  );
                                },
                              );
                            },
                            validator: (value) => (value.length == 10
                                ? "Please Enter valid phone number"
                                : ''),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              prefix: Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    "+91",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
//                                    borderSide:
//                                    BorderSide(color: Color(0xFFa1a1a1))),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              fillColor: Theme.of(context).primaryColor,
                              filled: true,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              decorationColor: Theme.of(context).primaryColor,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        RoundedButton(
                            text: "Submit",
                            onClick: () {
                              cardKey.currentState.toggleCard();
                              phoneAuthentication(phoneNumber);
                            })
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      back: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 225,
                    child: Text(
                      "Enter Verification Code",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Form(
                    key: _form1,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            left: 25.0,
                            right: 25.0,
                          ),
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() {
                                code = val;
                              });
                            },
                            validator: (value) => (value.length == 6
                                ? "Please enter valid code"
                                : ''),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Verification Code",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
//                                    borderSide:
//                                    BorderSide(color: Color(0xFFa1a1a1))),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              fillColor: Theme.of(context).primaryColor,
                              filled: true,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              decorationColor: Theme.of(context).primaryColor,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: InkWell(
                            child: Text(
                              "Go Back",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () => cardKey.currentState.toggleCard(),
                          ),
                          padding: EdgeInsets.only(
                            right: 30,
                            top: 10,
                            bottom: 10,
                          ),
                        ),
                        RoundedButton(
                          text: "Verify",
                          onClick: () {
                            successAuth();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
