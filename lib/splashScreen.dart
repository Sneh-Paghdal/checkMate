import 'dart:async';

import 'package:checkmate/Drawer/hidden_drawer.dart';
import 'package:checkmate/Pages/logInPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogIn();
  }

  checkLogIn() async {
    SharedPreferences prefers = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefers.getBool("isLoggedIn");
    if(isLoggedIn == true){
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>hiddenDrawer()));
      });
    }else{
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>logInPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child:
      Container(
        width: 200,
        child: Image.asset("assets/images/splashLogo.jpg"),
      )),
    );
  }
}
