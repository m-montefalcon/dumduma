import 'package:dumduma/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  User user;
  AddTodo(this.user);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  var FormKey = GlobalKey<FormState>();
  final  titleController = TextEditingController();
  final  descController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text("Todo Title", style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "E.g Clean house chores",
                    hintText: "Todo Title"
                ),
              ),
              SizedBox(height: 30),
              Text("Description", style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
              ),
              TextFormField(
                controller: descController,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "E.g Clean house chores at 8:00 P.M",
                    hintText: "Todo Description"
                ),
              ),
              SizedBox(height: 190),
              loading ?  CircularProgressIndicator():
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2))
                ),
                height: 40,
                width: 500,
                child: ElevatedButton(
                    onPressed: ()async{

                      if(titleController.text == ""|| descController.text == ""){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("All fields are required!"),
                              backgroundColor: Colors.red,
                            )
                        );
                      }else{
                        setState(() {
                          loading = true;
                        });
                        await FirestoreService().insertTodo(titleController.text, descController.text, widget.user.uid);
                        setState(() {
                          loading = false;
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,

                    ),
                    child: Text("Add Todo", style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),)

                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}
