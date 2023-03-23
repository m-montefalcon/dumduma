
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel{
  String id;
  String title;
  String description;
  Timestamp date;
  String userId;


  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userId
  });

  factory TodoModel.fromJson(DocumentSnapshot snapshot){
    return TodoModel(
        id: snapshot.id,
        title: snapshot['title'],
        description: snapshot['description'],
        date: snapshot['date'],
        userId: snapshot['userId']
    );
  }

}