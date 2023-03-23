import 'package:dumduma/screens/home_screen.dart';
import 'package:dumduma/screens/login_screen.dart';
import 'package:dumduma/services/auth_service.dart';
import 'package:dumduma/services/firestore_service.dart';
import 'package:dumduma/ui_helper/header_widget.dart';
import 'package:dumduma/ui_helper/theme_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage = '';

  bool checkedValue = false;
  bool checkboxValue = false;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerConfirmPassword = TextEditingController();

  TextEditingController _controllerLocation = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  Key _formKey = GlobalKey<FormState>();
  bool loading = false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.account_circle_rounded),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Text.rich(
                              TextSpan(
                                  children: [
                                    TextSpan(text: "Already have an account? "),
                                    TextSpan(
                                      text: 'Login',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                    ),
                                  ]
                              )
                          ),
                        ),

                        SizedBox(height: 30,),
                        Container(
                          child: TextField(
                            controller: _controllerName,
                            decoration: ThemeHelper().textInputDecoration("Name", "Enter your full name"),
                            keyboardType: TextInputType.text,

                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextField(
                            controller: _controllerEmail,
                            decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,

                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        Container(
                          child: TextField(
                            controller: _controllerPhone,
                            decoration: ThemeHelper().textInputDecoration("Phone number", "Enter your phone number"),
                            keyboardType: TextInputType.number,
                          ),

                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        Container(
                          child: TextField(
                            controller: _controllerLocation,
                            decoration: ThemeHelper().textInputDecoration("Address", "Enter your address"),
                            keyboardType: TextInputType.text,
                          ),

                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),


                        SizedBox(height: 20.0),



                        Container(
                          child: TextField(
                            controller: _controllerPassword,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password", "Enter your password"),

                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: TextField(
                            controller: _controllerConfirmPassword,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Confirm Passowrd", "Confirm your password"),

                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        loading ? CircularProgressIndicator():
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: ()async {
                              setState(() {
                                loading = true;
                              });
                              if(_controllerEmail.text == ""||_controllerPassword==""){
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                       content: Text("All fields are required!"),
                                     backgroundColor: Colors.red,
                                   )
                                );
                              }else if(_controllerPassword.text != _controllerConfirmPassword.text){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Password must be match"),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              }else{
                                User? result = await AuthService().registerUser(_controllerEmail.text, _controllerPassword.text, context, _controllerName.text,_controllerLocation.text, _controllerPhone.text );
                                if(result!=null){
                                  print("Success");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context)=>  HomeScreen(result)
                                      ),
                                          (route) => false);
                                }
                              }
                              setState(() {
                                loading = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30.0),

                        SizedBox(height: 25.0),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
