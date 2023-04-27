import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class attendence extends StatefulWidget {
  const attendence({Key? key}) : super(key: key);

  @override
  State<attendence> createState() => _attendenceState();
}

class _attendenceState extends State<attendence> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataSF();
  }

  List<dynamic> tempData = [];

  getDataSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempString = prefs.getString("permanentData");
    if(tempString != null){
      setState(() {
        tempData = jsonDecode(tempString);
      });
      // Fluttertoast.showToast(
      //     msg: "Data Loaded Successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 3,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 17.0);
    }
    dateFormator();
  }

  String todayDate = "";

  dateFormator(){
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('d - MMMM (M) - yy');
    todayDate = formatter.format(now);
  }

  bool floatingVisibility = true;

  onSubmit() async {
    for(int i = 0; i < tempData.length; i++){
      tempData[i]["date"] = todayDate;
    }
    var url =
    Uri.parse('https://script.google.com/macros/s/AKfycbyBXsvmAAJi0Q0Fr3suqp3dbiPVvmvs0RxchM4UnK8bUkxjCRd023KTEWA4xTTGYuzM9Q/exec');
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode(tempData);
    // print(body);
    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if(response.statusCode == 200 || response.statusCode == 302){
      Fluttertoast.showToast(
          msg: "Successfully Submitted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 17.0);
      setState(() {
        floatingVisibility = true;
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
      setState(() {
        floatingVisibility = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: floatingVisibility,
        child: FloatingActionButton.extended(
          onPressed: (){
            setState(() {
              floatingVisibility = false;
            });
            onSubmit();
          },
          icon: Icon(Icons.save),
          label: Text('Submit'),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 10,bottom: 150),
              child: ListView.builder(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount:tempData.length ,itemBuilder: (context,index){
                return Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
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
                  height: 130,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(margin: EdgeInsets.only(left: 10,top: 10,right: 10),child: Text("Name : ${tempData[index]['name']}",style: TextStyle(color: Colors.blue),)),
                            Container(margin: EdgeInsets.only(left: 10,top: 5,right: 10),child: Text("Enroll No. : ${tempData[index]['enrollmentNumber']}",style: TextStyle(color: Colors.blue),))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                tempData[index]["attendance"] = "Present";
                              });
                            },
                            child: Container(
                              height: 45,
                              width: 100,
                              margin: EdgeInsets.only(left: 10,top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: (tempData[index]["attendance"] == "Present") ? Colors.green.shade50 : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 5),
                                    )
                                  ]
                              ),
                              child: Center(child: Text("Present",style: TextStyle(color: Colors.green, fontWeight: FontWeight.w100),)),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                tempData[index]["attendance"] = "Absent";
                              });
                            },
                            child: Container(
                              height: 45,
                              width: 100,
                              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: (tempData[index]["attendance"] == "Absent") ? Colors.red.shade50 : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 5),
                                    )
                                  ]
                              ),
                              child: Center(child: Text("Absent",style: TextStyle(color: Colors.red, fontWeight: FontWeight.w100),)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
