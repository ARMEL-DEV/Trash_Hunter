import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Anonumous Authentication
  Future signInAnonumous() async {
    try {
      //AuthResult result = await _auth.signInAnonymously();

    } catch(e) {

    }
  }

  //Sign in with Phone Number
  /*PhoneAuthOptions options =
  PhoneAuthOptions.newBuilder(mAuth)
      .setPhoneNumber(phoneNumber)       // Phone number to verify
      .setTimeout(60L, TimeUnit.SECONDS) // Timeout and unit
      .setActivity(this)                 // (optional) Activity for callback binding
  // If no activity is passed, reCAPTCHA verification can not be used.
      .setCallbacks(mCallbacks)          // OnVerificationStateChangedCallbacks
      .build();
  PhoneAuthProvider.verifyPhoneNumber(options);*/

//Sign in with Email / Password

  //Register with Email / Password
  /*Future registerUser(String mobile, BuildContext context) async{
    _auth.verifyPhoneNumber(
        phoneNumber: null,
        timeout: Duration(),
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null
    );
  }*/

  //Sign out
}