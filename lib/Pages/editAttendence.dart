import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class editAttendence extends StatefulWidget {
  const editAttendence({Key? key}) : super(key: key);

  @override
  State<editAttendence> createState() => _editAttendenceState();
}

enum attendenceStat { Present, Absent }

class _editAttendenceState extends State<editAttendence> {
  TextEditingController searchControl = new TextEditingController();
  TextEditingController enrollmentController = new TextEditingController();
  List<dynamic> tempData = [];
  List<dynamic> filteredList = [];
  List<dynamic> datesList = [];
  String enrNum = "";
  String stuName = "";
  String postDate = "";
  String status = "";
  // String attendence = "";
  attendenceStat? attendence = attendenceStat.Present;
  bool isEditClicked = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataSF();
  }

  getDataSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempString = prefs.getString("permanentData");
    if (tempString != null) {
      setState(() {
        tempData = jsonDecode(tempString);
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
    String? tempdateList = prefs.getString("dates");
    if (tempdateList != null) {
      setState(() {
        datesList = jsonDecode(tempdateList);
        postDate = datesList[0];
      });
    }
  }

  updatePerticular() async {
    setState(() {
      isEditClicked = true;
    });
    var url = Uri.parse('https://script.google.com/macros/s/AKfycbziTjyEgUrcI64BZyigz9OJXckxYRsSy2x_aesYgbr35jPMZLiLr9stNk7lnu5852kAJw/exec');
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      "enrollmentNumber": enrNum,
      "date": postDate,
      "attendance" : attendence.toString() == "attendenceStat.Present" ? "Present" : "Absent"
    });
    print(body);
    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if(response.statusCode == 200 || response.statusCode == 302){
      Fluttertoast.showToast(
          msg: "Successfully Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 17.0);
      setState(() {
        isEditClicked = false;
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
        isEditClicked = false;
      });
    }
  }

  getDataOfCell() async {
    var url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbzWMf8xCQI-HYoZpZOpNINoJ-c8jxBTqvvKmi2SQ9PM70S03KaAtuyJfl48ro-CrdN67Q/exec');
    var headers = {
      'Content-Type': 'application/json',
      "Accept":"application/json"
    };
    var body = jsonEncode({
      "enrollmentNumber": enrNum,
      "date": postDate,
    });
    print(body);
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var resBody = response.body;
      print(resBody);
      // print(jsonDecode(resBody));
      // var resjson = jsonDecode(resBody);
      // status = resjson["value"];
      setState(() {
      });
      // Fluttertoast.showToast(
      //     msg: "${stuName} was ${resjson["value"]} on ${postDate}",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 5,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 17.0);
    } else if(response.statusCode == 302){
      Fluttertoast.showToast(
          msg: "Success But server is busy",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 17.0);
    } else {
      Fluttertoast.showToast(
          msg: "Student Not Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 17.0);
    }
  }

  onSearchTextChanged(String text) async {
    setState(() {
      if (searchControl.text.length == 1) {
        filteredList.clear();
      }
      var result = tempData
          .where((obj) =>
              obj['enrollmentNumber'].toString().contains(text.toString()))
          .toList();
      filteredList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10, left: 10, top: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(width: 1, color: Colors.green)),
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Container(
                    child: TextField(
                      controller: searchControl,
                      onChanged: onSearchTextChanged,
                      // enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Search Enrollment Number...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.search,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (filteredList.length == 0)
                ? Container()
                : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
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
                    // height: 200,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ListView.builder(
                        itemCount: filteredList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              enrNum = filteredList[index]["enrollmentNumber"].toString();
                              stuName = filteredList[index]["name"];
                              searchControl.text = enrNum;
                              filteredList.clear();
                              setState(() {
                              });
                              print(stuName);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              // color: ((index % 2) == 1)
                              //     ? Colors.grey.shade100
                              //     : Colors.grey.shade200,
                              height: 40,
                              child: Text(
                                  "${filteredList[index]["enrollmentNumber"]} - ${filteredList[index]["name"]}",overflow: TextOverflow.ellipsis,),
                            ),
                          );
                        }),
                  ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              height: 231,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date  :   ",style: TextStyle(color: Colors.blue),),
                      Container(
                        height: 40,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // color: Colors.blue.shade50,
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<dynamic>(
                            value: postDate,
                            onChanged: (newValue) {
                              setState(() {
                                postDate = newValue;
                              });
                            },
                            items: datesList.map((item) {
                              return DropdownMenuItem<dynamic>(
                                value: item,
                                child: Text(item.toString(),style: TextStyle(fontSize: 12,color: Colors.green),),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text("Enroll No.  : ${enrNum}",style: TextStyle(color: Colors.blue),),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 5),
                  //   height: 45,
                  //   padding: EdgeInsets.only(top: 15),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Colors.grey.shade200,
                  //   ),
                  //   alignment: Alignment.centerLeft,
                  //   child: TextField(
                  //     controller: enrollmentController,
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //     //     borderRadius: BorderRadius.circular(10.0),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //     //   focusedBorder: OutlineInputBorder(
                  //     //     borderRadius: BorderRadius.circular(10.0),
                  //     //     borderSide: BorderSide.none,
                  //     //   ),
                  //     //   filled: true,
                  //       // fillColor: Colors.grey[200],
                  //       hintText: '21*****3820*',
                  //     )
                  //   ),
                  // )
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text("Name  : ",style: TextStyle(color: Colors.blue)),
                        Text("${stuName}",style: TextStyle(color: Colors.blue),)
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 10),
                  //   child: Row(
                  //     children: [
                  //       Text("Student Status  : "),
                  //       Text("${status}",style: TextStyle(fontSize: 18,color: (status == "Present") ? Colors.green : Colors.red),)
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 35,
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
                            child: Row(
                              children: [
                                Radio<attendenceStat>(
                                  visualDensity: const VisualDensity(
                                      horizontal:
                                      VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  value: attendenceStat.Present,
                                  groupValue: attendence,
                                  onChanged: (attendenceStat? value) {
                                    setState(() {
                                      attendence = value;
                                    });
                                  },
                                ),
                                Flexible(child: Text("Present"))
                              ],
                            ),
                          ),
                        ),
                        Expanded(flex: 1,child: Container()),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 35,
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
                            child: Row(
                              children: [
                                Radio<attendenceStat>(
                                  visualDensity: const VisualDensity(
                                      horizontal:
                                      VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  value: attendenceStat.Absent,
                                  groupValue: attendence,
                                  onChanged: (attendenceStat? value) {
                                    setState(() {
                                      attendence = value;
                                    });
                                  },
                                ),
                                Flexible(child: Text("Absent"))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (isEditClicked == false) {
                        setState(() {
                          updatePerticular();
                        });
                      }
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
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
                      child: Center(child: Text("Edit",style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w100),)),
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
