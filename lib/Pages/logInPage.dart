import 'dart:convert';

import 'package:checkmate/Drawer/hidden_drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class logInPage extends StatefulWidget {
  const logInPage({Key? key}) : super(key: key);

  @override
  State<logInPage> createState() => _logInPageState();
}

class _logInPageState extends State<logInPage> {
  TextEditingController userNameLogIn = new TextEditingController();
  TextEditingController passwordLogIn = new TextEditingController();
  TextEditingController userNameSignUp = new TextEditingController();
  TextEditingController passwordSignUp = new TextEditingController();
  TextEditingController _mobileNumber = new TextEditingController();
  TextEditingController _code = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredsAPI();
  }

  bool isSignUp = false;
  bool isProccessing = false;
  List<dynamic> credsList = [];

  getCredsAPI() async {
    const url =
        'https://script.google.com/macros/s/AKfycbyjJZz4KLVIfZUf7aX2bzwnzrVFAmGZuUkrQIOAEa5CooFMeYvQt3fumAJicczQP55l/exec';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    // print(json);
    // print("object" + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 302) {
      setState(() {
        credsList = json;
        // print(credsList);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Either your net is off or developers on vacations",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 17.0);
    }
  }

  chechValidUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isMatch = false;
    if(credsList.length != 0){
      for(int i = 0; i < credsList.length; i++){
        if(credsList[i]["userId"].toString() == userNameLogIn.text.toString()){
          print("${credsList[i]["userId"]} == ${userNameLogIn.text.toString()}");
          if(credsList[i]["password"].toString() == passwordLogIn.text.toString()){
            print("${credsList[i]["password"]} == ${passwordLogIn.text.toString()}");
            isMatch = true;
            prefs.setBool("isLoggedIn", true);
            break;
          }
        }
      }
      if(isMatch){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>hiddenDrawer()));
        setState(() {});
        Fluttertoast.showToast(
            msg: "Logged In Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 17.0);
      }else{
        Fluttertoast.showToast(
            msg: "Invalid Username or Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 17.0);
      }
    }else{
      Fluttertoast.showToast(
          msg: "Please wait because system is slow, Tap Again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 17.0);
    }
  }

  signUpUserAPI() async {
    var url =
    Uri.parse('https://script.google.com/macros/s/AKfycbzld1JjFeP-eEes57eW-MCH_f--LgffaCgnj-ewzTbc8rXh_xpXv4LQvkPZP2xPigjh/exec');
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
        "userId" : userNameSignUp.text.toString(),
        "password" : passwordSignUp.text.toString(),
        "mobileNumber" : _mobileNumber.text.toString(),
        "code" : _code.text.toString()
    });
    // print(body);
    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if(response.statusCode == 200){
      final body = response.body;
      final json = jsonDecode(body);
      credsList = json;
      print(json);
      setState(() {
        isSignUp = false;
        isProccessing = false;
      });
    }else if(response.statusCode == 302){
      getCredsAPI();
      setState(() {
        isSignUp = false;
        isProccessing = false;
      });
    }else{
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 17.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                )
              ]
          ),
          height: (isSignUp == false ) ? 300 : 450,
          child : (isSignUp == false ) ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("Log In",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 5,bottom: 5,top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: TextField(
                    controller: userNameLogIn,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                      ),
                      labelText: 'User Name* ',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 5,bottom: 5,top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: passwordLogIn,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Password* ',
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  // print("Tapped");
                  if(userNameLogIn.text.trim().toString() == "" || passwordLogIn.text.trim().toString() == ""){
                    Fluttertoast.showToast(
                        msg: "Invalid Username or Password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 17.0);
                  }else{
                    chechValidUser();
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue.shade50,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: Center(child: Text("log In",style: TextStyle(color: Colors.blue),)),
                ),
              ),
              InkWell(
                onTap: (){
                  isSignUp = true;
                  setState(() {
                  });
                },
                child: Container(
                  child: Text("Don't Have Account? Sign Up",style: TextStyle(color: Colors.red),),
                ),
              ),
            ],
          )
              :
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("Sign Up",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 5,bottom: 5,top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: TextField(
                    controller: userNameSignUp,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'User Name* ',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 5,bottom: 5,top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: passwordSignUp,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Password* ',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 5,bottom: 5,top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: _mobileNumber,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Mobile Number* ',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 5,bottom: 5,top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: _code,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Code* ',
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  if(!isProccessing){
                    if(userNameSignUp.text.trim().toString() == "" || passwordSignUp.text.trim().toString() == ""){
                    Fluttertoast.showToast(
                        msg: "Invalid Username or Password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 17.0);
                  }else if(_mobileNumber.text.toString().isEmpty){
                      Fluttertoast.showToast(
                          msg: "Please enter mobile number",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 17.0);
                    }else if(_code.text.toString() != "0000" && _code.text.toString() != "3113"){
                      Fluttertoast.showToast(
                          msg: "Please contact developer to signUp",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 17.0);
                    }else{
                      isProccessing = true;
                      setState(() {
                      });
                      signUpUserAPI();
                    }
                  }else{
                    Fluttertoast.showToast(
                        msg: "Please wait...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 17.0);
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue.shade50,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ]
                  ),
                  child: Center(child: Text("Sign Up",style: TextStyle(color: Colors.blue),)),
                ),
              ),
              InkWell(
                onTap: (){
                  isSignUp = false;
                  setState(() {
                  });
                },
                child: Container(
                  child: Text("Already Have Account? Log in",style: TextStyle(color: Colors.red),),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
