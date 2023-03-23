import 'package:dumduma/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Register User
  Future <User?> registerUser(String email, String password,
      BuildContext context, String name, String location, String phoneNumber) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;
      await FirestoreService().insertUsers(name, email, location, phoneNumber, userId);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text
              (e.message.toString()
            ),
            backgroundColor: Colors.red,
          )
      );
    } catch (e) {
      print(e);
    }
  }
  //Login User
  Future<User?> loginUser(String email, String password,
      BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text
              (e.message.toString()
            ),
            backgroundColor: Colors.red,
          )
      );
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    await firebaseAuth.signOut();
  }
}