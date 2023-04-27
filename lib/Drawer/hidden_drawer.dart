import 'package:checkmate/Pages/attendence.dart';
import 'package:checkmate/Pages/attendenceList.dart';
import 'package:checkmate/Pages/editAttendence.dart';
import 'package:checkmate/Pages/logInPage.dart';
import 'package:checkmate/Pages/logOut.dart';
import 'package:checkmate/main.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class hiddenDrawer extends StatefulWidget {
  const hiddenDrawer({Key? key}) : super(key: key);

  @override
  State<hiddenDrawer> createState() => _hiddenDrawerState();
}

class _hiddenDrawerState extends State<hiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      ScreenHiddenDrawer(ItemHiddenMenu(name: "Student List" ,baseStyle: TextStyle(color: Colors.black),selectedStyle: TextStyle(color: Colors.white,fontSize: 18)), attendenceList()),
      ScreenHiddenDrawer(ItemHiddenMenu(name: "Attendance" ,baseStyle: TextStyle(color: Colors.black),selectedStyle: TextStyle(color: Colors.white,fontSize: 18)), attendence()),
      ScreenHiddenDrawer(ItemHiddenMenu(name: "Edit Attendance" ,baseStyle: TextStyle(color: Colors.black),selectedStyle: TextStyle(color: Colors.white,fontSize: 18)), editAttendence()),
      ScreenHiddenDrawer(ItemHiddenMenu(name: "Log Out" ,baseStyle: TextStyle(color: Colors.black),selectedStyle: TextStyle(color: Colors.white,fontSize: 18)), logOut())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(screens: _pages,isTitleCentered : true, backgroundColorMenu: Colors.deepPurple.shade200,initPositionSelected: 0,slidePercent: 66,);
  }
}
