import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_kit/LoginPage.dart';
import 'package:med_kit/RegisterPage.dart';
import 'package:intl/intl.dart';
import '../Main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login Function
  Future<User?> logInToSystem(String email, String password) async {
    var user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      MainPageState.loggedInUserKey = email;
    } on FirebaseAuthException catch (e) {
      if(e.message != null) {
        LoginPageState.informationInvalid = true;
      }
      return user.user;
    }
    return user.user;
  }

  // Sign out function
  signOut() async {
    return await _auth.signOut();
  }

  // Register function
  Future<User?> registerToSystem(
      String name, String email, String password,
      String passwordRepeat, String gender, bool checked) async {

    // Consent text checked or not: Check other fields first.
    if(name.isEmpty || email.isEmpty || password.isEmpty)
    {
      RegisterPageState.registerInformationInvalid = true;
      RegisterPageState.errorMessage = "Please input your information.";
      var user =
      await _auth.createUserWithEmailAndPassword(email: "", password: "");
      return user.user;
    }

    // Check passwords are equal.
    if(password != passwordRepeat)
    {
        RegisterPageState.registerInformationInvalid = true;
        RegisterPageState.errorMessage = "Passwords should match.";
        var user =
        await _auth.createUserWithEmailAndPassword(email: "", password: "");
        return user.user;
    }

    // Check input box has checked.
    if (checked) {
      var user;
      try {
        user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        FirebaseFirestore.instance.collection('Med-Kit User').get().then((value) =>
        {
          _firestore
            .collection("Med-Kit User")
            .doc(user.user!.uid)
            .set({
          'userName': name,
          'email': email,
          "note": "",
          "ID": (value.docs.length + 1),
            "date": DateFormat('yMd').format(DateTime.now()).toString(),
            "gender": gender
        })
        });

      } on FirebaseAuthException catch (e) {
        // Catch another issues
        switch (e.message)
        {
          case "The email address is already in use by another account.":
            {
              RegisterPageState.registerInformationInvalid = true;
              RegisterPageState.errorMessage = "E-mail is in use.";
              break;
            }
          case "The email address is badly formatted.":
            {
              RegisterPageState.registerInformationInvalid = true;
              RegisterPageState.errorMessage = "E-mail format is invalid.";
              break;
            }
        }
        return user.user;
      }
      return user.user;
    }
    else {
      RegisterPageState.registerInformationInvalid = true;
      RegisterPageState.errorMessage = "Please confirm the consent text.";
      var user =
          await _auth.createUserWithEmailAndPassword(email: "", password: "");
      return user.user;
    }
  }

}
