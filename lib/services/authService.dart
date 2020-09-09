import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/screens/homePage.dart';
import 'package:restaurant_app/screens/phone_auth_screen.dart';

class AuthService{
  handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snap){
        if(snap.hasData){
          return HomePage();
        }else{
          return PhoneAuth();
        }
      },
    );
  }

  logout(){
    FirebaseAuth.instance.signOut();
  }

  login(AuthCredential auth){
    FirebaseAuth.instance.signInWithCredential(auth);
  }

  loginWithOTP(sms,verId){
    AuthCredential auth = PhoneAuthProvider.credential(verificationId: verId, smsCode: sms);
    login(auth);
  }
}