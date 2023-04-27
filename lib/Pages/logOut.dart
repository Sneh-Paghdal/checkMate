import 'package:checkmate/Drawer/hidden_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logInPage.dart';

class logOut extends StatefulWidget {
  const logOut({Key? key}) : super(key: key);

  @override
  State<logOut> createState() => _logOutState();
}

class _logOutState extends State<logOut> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100), ()
    {
      confirmLogout(context);
    });
  }

  confirmLogout(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user can tap outside dialog to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => hiddenDrawer()));
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("isLoggedIn");
                setState(() {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>logInPage()));
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Container(
        //   margin: EdgeInsets.only(left: 10,right: 10),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(15),
        //     color: Colors.white,
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.grey.shade300,
        //           spreadRadius: 1,
        //           blurRadius: 5,
        //           offset: const Offset(0, 5),
        //         )
        //       ]
        //   ),
        //   height: 130,
        //   width: double.infinity,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Container(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Container(margin: EdgeInsets.only(left: 10,top: 10,right: 10),child: Text("Name : Sneh Kishorbhai Paghdal",style: TextStyle(color: Colors.blue),)),
        //             Container(margin: EdgeInsets.only(left: 10,top: 5,right: 10),child: Text("Enroll No. : 210090107010",style: TextStyle(color: Colors.blue),))
        //           ],
        //         ),
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           Container(
        //             height: 45,
        //             width: 100,
        //             margin: EdgeInsets.only(left: 10,right: 10,top: 5),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(50),
        //                 color: Colors.white,
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Colors.grey.shade300,
        //                     spreadRadius: 1,
        //                     blurRadius: 5,
        //                     offset: const Offset(0, 5),
        //                   )
        //                 ]
        //             ),
        //             child: Center(child: Text("Present",style: TextStyle(color: Colors.green, fontWeight: FontWeight.w100),)),
        //           ),
        //           Container(
        //             height: 45,
        //             width: 100,
        //             margin: EdgeInsets.only(left: 10,right: 10,top: 5),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(50),
        //                 color: Colors.red.shade50,
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Colors.grey.shade300,
        //                     spreadRadius: 1,
        //                     blurRadius: 5,
        //                     offset: const Offset(0, 5),
        //                   )
        //                 ]
        //             ),
        //             child: Center(child: Text("Absent",style: TextStyle(color: Colors.red, fontWeight: FontWeight.w100),)),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
