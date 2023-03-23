import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumduma/models/firebase_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future insertTodo(String title, String description, String userId)async{
    try{
      await firestore.collection('todo').add({
        'title': title,
        'description': description,
        'date': DateTime.now(),
        'userId': userId
      });
    } catch (e){
      print(e);

    }
  }


  Future insertUsers(String name, String email, String address, String phoneNumber, String userId)async{
    try{
      await firestore.collection('users').add({
        'name': name,
        'email': email,
        'address': address,
        'phoneNumber': phoneNumber,
        'userId': userId
      });
    } catch (e){
      print(e);
    }
  }



  Future updateTodo(String docId, String title, String description)async{
    try{
      await firestore.collection('todo').doc(docId).update({
        'title': title,
        'description': description
      });
    }
    catch (e){
      print(e);
    }
  }

  Future deleteTodo(String docId)async{
    try{
      await firestore.collection('todo').doc(docId).delete();
    } catch(e){
      print(e);
    }
  }
}