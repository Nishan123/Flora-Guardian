import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flora_guardian/models/user_model.dart';
import 'package:flutter/widgets.dart';

class UserController {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String getCurrentUser() {
    return _auth.currentUser!.uid.toString();
  }

  Future login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future saveUseToDb(UserModel user) async {
    try {
      await _db.collection("users").doc(getCurrentUser()).set(user.toJson());
    } catch (e) {
      debugPrint("Failed to add user to db: ${e.toString()}");
    }
  }

  Future logOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint("Cannot logout ${e.toString()}");
    }
  }

  Future signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }
}
