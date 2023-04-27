import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class attendenceList extends StatefulWidget {
  const attendenceList({Key? key}) : super(key: key);

  @override
  State<attendenceList> createState() => _attendenceListState();
}

class _attendenceListState extends State<attendenceList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentList();
  }

  List<dynamic> data = [
    // [
    //   "Enrollment Number",
    //   "Name",
    //   "23 - April (4) - 23",
    //   "25 - April (4) - 23"
    // ],
    // [
    //   210090107010,
    //   "Sneh Kishorbhai Paghdal",
    //   "Present",
    //   "Absent"
    // ],
    // [
    //   210090107022,
    //   "Akshar Sanjaybhai Kevadiya",
    //   "Absent",
    //   "Present"
    // ],
    // [
    //   210090107024,
    //   "Lomash Dhirubhai Bhuva",
    //   "Present",
    //   "Present"
    // ],
    // [
    //   210090107123,
    //   "Dev D. Dhorajiya",
    //   "Absent",
    //   "Present"
    // ],
    // [
    //   210090107004,
    //   "Dhruval Ganeshbhai Dobariya",
    //   "Present",
    //   "Absent"
    // ]
  ];

  List<dynamic> tempData = [];

  storeToSharedPrefs(data) async {
    for(int i = 1; i<data.length; i++){
      // for(int j = 0; j<data[0].length; j++){
        var obj = {
          "enrollmentNumber": data[i][0],
          "name" : data[i][1],
          "attendance": "Absent",
          "date" : null,
        };
      // }
      tempData.add(obj);
    }
    List<dynamic> dates = [];
    for(int i = 2; i < data[0].length; i++){
      dates.add(data[0][i]);
    }
    String tempDataString = jsonEncode(tempData);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("permanentData", tempDataString);
    String tempDates = jsonEncode(dates);
    prefs.setString("dates", tempDates);
    // print(tempDataString);
  }

  getStudentList() async {
    const url =
        'https://script.google.com/macros/s/AKfycby7mEKX4tzS2rdTUPQLGdQY4ukyx311aHxiqN_rELdn7nSnJ3WVt5jtBodALeww-cDC/exec';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    // print(json);
    // print("object" + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 302) {
      setState(() {
        data = json;
      });
      Fluttertoast.showToast(
          msg: "Data Loaded Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 17.0);
      storeToSharedPrefs(data);
      // getDataAPI();
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

  // getDataAPI() async {
  //   var postBody = {
  //       "id" : "1teqoNOsY8U4p1rVWgjkpPvUwCZxS45n6L1b1hVjin6o"
  //   };
  //   // var headers = {
  //   //   'Content-Type': 'application/json',
  //   // };
  //   const url =
  //       'https://script.google.com/macros/s/AKfycbwV14LYUrcrLpl4l62t9s4C8Iy1yDvUG2-MVVeypyQScN7xB_9Gzm-2vJcwgdQMoVS8vw/exec';
  //   final uri = Uri.parse(url);
  //   final response = await http.post(uri,body: jsonEncode(postBody), headers: {'Content-Type': 'Application/Json'});
  //   // print(response.statusCode);
  //   // print("postdata : " + json.toString());
  //   print("object////////////////////////    " + response.statusCode.toString());
  //   if (response.statusCode == 200 || response.statusCode == 302) {
  //     final body = response.body;
  //     print(body.toString());
  //     // final json = jsonDecode(body);
  //     setState(() {
  //       // data = json;
  //     });
  //     Fluttertoast.showToast(
  //         msg: "Data Loaded Successfully",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 3,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 17.0);
  //     storeToSharedPrefs(data);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Either your net is off or developers on vacations",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 4,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 17.0);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (data.length == 0)
          ? Container(
              margin: EdgeInsets.all(20),
              child: Center(
                  child: Text(
                      "Please wait, retrieving the data from the server...")),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DataTable(
                    columnSpacing: 10,
                    columns: List.generate(data[0].length, (index) {
                      return DataColumn(
                          label: Text(
                        data[0][index],
                        style: TextStyle(),
                        maxLines: 2,
                      ));
                    }),
                    rows: List.generate(data.length - 1, (index) {
                      return DataRow(
                          cells: List.generate(data[0].length, (cellIndex) {
                        return DataCell(
                            Text(data[index + 1][cellIndex].toString()));
                      }));
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
