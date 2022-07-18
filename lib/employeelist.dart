import 'dart:io';

import 'package:flutter/material.dart';
import 'package:offline/model/employee.dart';
import 'dart:async';
import 'package:offline/database/dbhelper.dart';

import 'model/employee.dart';

Future<List<Employee>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Employee>> employees = dbHelper.getEmployees();
  return employees;
}

class MyEmployeeList extends StatefulWidget {
  @override
  MyEmployeeListPageState createState() => new MyEmployeeListPageState();
}

class MyEmployeeListPageState extends State<MyEmployeeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Employee List'),
      ),
      body: Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<Employee>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[


                            Container(
                              width:MediaQuery.of(context).size.width,
                            color: Colors.white10,
                            child:  Row(
                                children: [
                                   Row(
                                     children: [
                                       Container(
                                        child: Image.file(File(snapshot.data![index].firstName!),
                                          fit: BoxFit.fill,
                                          width: 80,
                                          height: 80,
                                        ),
                                  ),
                                       SizedBox(width: 10),
                                       Container(
                                         child: Image.file(File(snapshot.data![index].lastName!),
                                           fit: BoxFit.fill,
                                           width: 80,
                                           height: 80,
                                         ),
                                       ),

                                      Container(

                                        width: 160,
                                        height: 80,
                                        child: Column(
                                           children: [
                                             new Text(snapshot.data![index].mobileNo!,
                                                 style: new TextStyle(
                                                     fontWeight: FontWeight.bold, fontSize: 14.0)),


                                           ],
                                         ),
                                      ),

                                       GestureDetector(
                                         onTap: (){
                                           var dbHelper = DBHelper();
                                           dbHelper.deletetable();
                                           setState(() {

                                           });

                                             },

                                         child: Container(

                                           width: 40,
                                           height: 80,
                                           child: Image(
                                                image: AssetImage(
                                                    'assets/delete.png'
                                           ),

                                         ),
                                         ),
                                       ),

                                     ],
                                   ),

                                ],
                              ),
                    ),



                          
                          // new Text(snapshot.data![index].firstName!,
                          //     style: new TextStyle(
                          //         fontWeight: FontWeight.bold, fontSize: 18.0)),

                          new Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}