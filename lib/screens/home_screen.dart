import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumduma/main.dart';
import 'package:dumduma/models/todo.dart';
import 'package:dumduma/screens/add_todo.dart';
import 'package:dumduma/screens/developer_profile_page.dart';
import 'package:dumduma/screens/edit_todo.dart';
import 'package:dumduma/screens/profile_screen.dart';
import 'package:dumduma/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  User user;
  HomeScreen(this.user);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  double  _drawerIconSize = 24;
  double _drawerFontSize = 17;

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
      drawer: Drawer(
        child: Container(
          decoration:BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).accentColor.withOpacity(0.5),
                  ]
              )
          ) ,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [ Theme.of(context).primaryColor,Theme.of(context).accentColor,],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text("Dumduma",
                    style: TextStyle(fontSize: 25,color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_filled, size: _drawerIconSize, color: Theme.of(context).accentColor,),
                title: Text('Home Page', style: TextStyle(fontSize: 17, color: Theme.of(context).accentColor),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomeScreen(user)));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle_rounded,size: _drawerIconSize,color: Theme.of(context).accentColor),
                title: Text('Profile Page', style: TextStyle(fontSize: _drawerFontSize, color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(user)));
                },
              ),
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.code, size: _drawerIconSize,color: Theme.of(context).accentColor),
                title: Text('Developer Profile Information',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).accentColor),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeveloperProfilePage()),);
                },
              ),
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.logout_rounded, size: _drawerIconSize,color: Theme.of(context).accentColor,),
                title: Text('Logout',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).accentColor),),
                onTap: () async{
                  await AuthService().signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: ((context) => MyApp())));
                },
              ),
            ],
          ),
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('todo').where('userId', isEqualTo: user.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length > 0){
              return ListView.builder(
                padding: EdgeInsets.all(7),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    TodoModel todo = TodoModel.fromJson(snapshot.data.docs[index]);
                    return Card(
                      elevation: 5,
                      color: Colors.purple.shade200,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(todo.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        subtitle: Text(todo.description, overflow: TextOverflow.ellipsis,maxLines: 2),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditTodo(todo)));
                        },
                      ),
                    );
                  }
              );

            }else{
              return Center(
                  child: Text(
                      "No Remiders Available"
                  )
              );
            }

          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      ),
      floatingActionButton: FloatingActionButton.extended(

          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  AddTodo(user)
                )
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text("Add Reminder")
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/*      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: ()async{
                  CollectionReference users = firestore.collection('users');
                  // await users.add({
                  //   "name": 'Meinardz Sample'
                  // });
                  await users.doc("todo").set({
                    'name': "sample"
                  });
                },
                child: Text("Add data to firestore")
            ),
            ElevatedButton(
                onPressed: ()async{
                  CollectionReference users = firestore.collection('users');
                  // QuerySnapshot allResults = await users.get();
                  // allResults.docs.forEach((DocumentSnapshot result) {
                  //   print(result.data());
                  // });
                  // DocumentSnapshot result = await users.doc('todo').get();
                  // print(result.data());
                  users.doc('todo').snapshots().listen((result) {
                    print(result.data());
                  });
                },
                child: Text("Read data to firestore")
            ),
            ElevatedButton(
                onPressed: ()async{
                  await firestore.collection('users').doc('todo').update(
                    {
                      'name' : 'update data'
                    }
                  );
                },
                child: Text("Update data to firestore")
            ),
            ElevatedButton(
                onPressed: ()async{
                  await firestore.collection('users').doc('todo').delete();
                },
                child: Text("Delete data to firestore")
            ),
          ],
        ),

      ),*/
