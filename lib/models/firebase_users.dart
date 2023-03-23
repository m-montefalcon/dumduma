
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumduma/ui_helper/header_widget.dart';
import 'package:flutter/material.dart';

class FirebaseUsers{
  String id;
  String name;
  String email;
  String address;
  String phoneNumber;
  String userId;


  FirebaseUsers({
    required this.id,
    required this.email,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.userId
  });

  factory FirebaseUsers.fromJson(DocumentSnapshot snapshot){
    return FirebaseUsers(
        id: snapshot.id,
        email: snapshot['email'],
        name: snapshot['name'],
        address: snapshot['address'],
        phoneNumber: snapshot['phoneNumber'],
        userId: snapshot['userId']
    );
  }
  SingleChildScrollView toListTile() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(height: 100, child: HeaderWidget(100,false,Icons.house_rounded),),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  child: Icon(Icons.verified_user, size: 100,),
                ),
                SizedBox(height: 20,),
                Text("Profile Information", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.topLeft,
                        child: Center(
                          child: Text(
                            " ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  ...ListTile.divideTiles(
                                    color: Colors.grey,
                                    tiles: [
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        leading: Icon(Icons.drive_file_rename_outline),
                                        title: Text("Name"),
                                        subtitle: Text(name),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.location_city),
                                        title: Text("Address"),
                                        subtitle: Text(address),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.numbers),
                                        title: Text("Phone Number"),
                                        subtitle: Text(phoneNumber),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.email),
                                        title: Text("Email"),
                                        subtitle: Text(
                                            email),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),

    );
  }
}