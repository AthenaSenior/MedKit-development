import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_kit/LoginPage.dart';
import 'package:med_kit/RegisterPage.dart';
import 'package:intl/intl.dart';
import '../Main.dart';
import '../Profile.dart';

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

  updateUserAuthInformationEmail(String email) async {
    try{
      final update = await FirebaseAuth.instance.currentUser!.updateEmail(email);
      ProfileState.error = false;
      return update;
    }
    catch(error) {
      ProfileState.error = true;
      ProfileState.errorMessage = error.toString();
    }
  }

  changePassword(String currentPassword, String newPassword) async {

    if(newPassword.length < 6)
    {
      ProfileState.error = true;
      ProfileState.errorMessage = "Password length should not be less than 6 characters.";
      return;
    }

    try{
      //Create an instance of the current user.
      var user = await _auth.currentUser!;
      final cred = await _auth.signInWithEmailAndPassword(
          email: user.email!, password: currentPassword); // Try to login
      await user.updatePassword(newPassword); // If successfully login, it means old pass is true. So set the password as new
      ProfileState.error = false;
      return cred;
    }
    catch(error) {
     ProfileState.error = true;
     ProfileState.errorMessage = "Current password is invalid.";
    }
  }

  void resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
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

    if(name.length < 6)
      {
        RegisterPageState.registerInformationInvalid = true;
        RegisterPageState.errorMessage = "Name should not be less than 6 characters.";
        var user =
        await _auth.createUserWithEmailAndPassword(email: "", password: "");
        return user.user;
      }

    if(password.length < 6)
      {
        RegisterPageState.registerInformationInvalid = true;
        RegisterPageState.errorMessage = "Password should not be less than 6 characters.";
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
