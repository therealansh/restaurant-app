import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/screens/homePage.dart';
import 'package:restaurant_app/screens/phone_auth_screen.dart';

//Authentication Service Class
class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.hasData) {
          return HomePage(
            phone: phone,
          );
        } else {
          return PhoneAuth();
        }
      },
    );
  }

  //Logout
  logout() {
    FirebaseAuth.instance.signOut();
  }

  //login
  login(AuthCredential auth) {
    FirebaseAuth.instance.signInWithCredential(auth);
  }

  //verify otp
  loginWithOTP(sms, verId) {
    AuthCredential auth =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: sms);
    login(auth);
  }
}
