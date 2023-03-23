import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumduma/models/firebase_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage(this.user);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? _value;

  void initState() {
    super.initState();
    getUserValue();
  }
  void getUserValue() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _value = (snap.data() as Map<String, dynamic>)['users'];
    });
  }
  Stream<List<FirebaseUsers>> getUsersStream() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => FirebaseUsers.fromJson(doc)).toList());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace:Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
                )
            ),
          ),
        ),
        body: StreamBuilder<List<FirebaseUsers>>(
          stream: getUsersStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            List<FirebaseUsers> users = snapshot.data!;
            List<Widget> userTiles = users.map((user) => user.toListTile()).toList();

            return ListView(
              children: userTiles,
            );
          },
        )
    );
  }
}
