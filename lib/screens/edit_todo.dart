import 'package:dumduma/models/todo.dart';
import 'package:dumduma/screens/home_screen.dart';
import 'package:dumduma/services/firestore_service.dart';
import 'package:flutter/material.dart';

class EditTodo extends StatefulWidget {
  TodoModel todo;
  EditTodo(this.todo);

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    titleController.text = widget.todo.title;
    descriptionController.text = widget.todo.description;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Todo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
          onPressed: ()async{
            await showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Confirm Deletion"),
                    content: Text("Are you sure you want to delete this reminder?"),
                    actions: [
                      TextButton(onPressed: ()async{
                        await FirestoreService().deleteTodo(widget.todo.id);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }, child: Text("Yes")),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("No"))
                    ],
                  );

                }
            );
          },
            icon: Icon(Icons.delete, color: Colors.red)
            )
        ],
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
              // Text(widget.todo.date.toDate(), style: TextStyle(
              //     fontSize: 30,
              //     fontWeight: FontWeight.bold
              // ),
              // ),
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
                  hintText: "Todo Title",
                ),
              ),
              SizedBox(height: 30),
              Text("Description", style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
              ),
              TextFormField(
                controller: descriptionController,
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
                      if(titleController.text == ""|| descriptionController.text == ""){
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
                        await FirestoreService().updateTodo(widget.todo.id, titleController.text, descriptionController.text);
                        setState(() {
                          loading = false;
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,

                    ),
                    child: Text("Edit Todo", style: TextStyle(
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
