import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_kit/main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login Function
  Future<User?> logInToSystem(String email, String password) async {
    var user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
      LoginPageState.informationInvalid = true;
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
      String name, String email, String password, bool checked) async {
    if (checked) {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _firestore
          .collection("Med-Kit User")
          .doc(user.user!.uid)
          .set({'userName': name, 'email': email});
      print(checked);
      return user.user;
    } else {
      RegisterPageState.registerInformationInvalid = true;
      RegisterPageState.errorMessage = "asdasd";
      var user =
          await _auth.createUserWithEmailAndPassword(email: "", password: "");
      return user.user;
    }
  }
}
