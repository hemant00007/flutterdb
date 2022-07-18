//import packages
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offline/database/dbhelper.dart';
import 'package:offline/model/employee.dart';
import 'package:offline/employeelist.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Test',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 // MyHomePage({Key key, this.title}) : super(key: key);
 // final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  var choosedimage;
  List<String> uploadfile=[];
  var tmpimgArray = [];

  Employee employee = new Employee("", "", "", "");

  String? firstname="test";
  String? lastname="test";
  String? emailId="test";
  String? mobileno="test";
  String? myimage;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
          title: new Text('My Test'),
          actions: <Widget>[
            new IconButton(
              icon: const Icon(Icons.view_list),
              tooltip: 'Next choice',
              onPressed: () {
                navigateToEmployeeList();
              },
            ),
          ]
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              Visibility(
                visible:false,
                child: new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: 'First Name'),
                  validator: (val) =>
                  val?.length == 0 ?"Enter FirstName" : null,
                  onSaved: (val) => this.firstname = val,
                ),
              ),
              Visibility(
                visible: false,
                child: new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: 'Last Name'),
                  validator: (val) =>
                  val?.length ==0 ? 'Enter email' : null,
                  onSaved: (val) => this.lastname = val,
                ),
              ),
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Enter name'),
                validator: (val) =>
                val?.length ==0 ? 'Enter name' : null,
                onSaved: (val) => this.mobileno = val,
              ),
              Visibility(
                visible: false,
                child: new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(labelText: 'Enter email'),
                  validator: (val) =>
                  val?.length ==0 ? 'Enter Email Id' : null,
                  onSaved: (val) => this.emailId = val,
                ),
              ),
              SizedBox(height: 20),


                Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                   width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Capture image",style: TextStyle(color: Colors.white,fontSize: 20),),
                        )),
                      ],
                    )),
              SizedBox(height: 20,),

              GestureDetector(
                  onTap: (){

           //     chooseImage();
                    if(tmpimgArray.length<2){
                      pickImage();
                    }else{
                      print("no more image");
                      _showSnackBar("no more image");
                    }

                  },
                  child: Image(image: AssetImage('assets/image.png'))),

                    Container(
                      height: 120,

                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: uploadfile.length,
                          itemBuilder: (context,c)
                          {
                            return Card(
                              child: Image.file(File(uploadfile[c]),
                                fit: BoxFit.fill,
                                width: 120,
                                height: 120,

                              ),
                            );
                          }
                      ),
                    ),


              new Container(margin: const EdgeInsets.only(top: 10.0),child: new RaisedButton(onPressed: _submit,
                child: new Text('Save Employee'),),)

            ],
          ),
        ),
      ),
    );
  }
  void _submit() {
    if (this.formKey.currentState!.validate() ) {
      formKey.currentState?.save();
    }
    else{
      return null;
    }
    if(tmpimgArray.length<2){
      _showSnackBar("Add two images");
    }else {
      var employee = Employee(uploadfile[0],uploadfile[1],mobileno,emailId,);
      var dbHelper = DBHelper();
      dbHelper.saveEmployee(employee);
      _showSnackBar("Data saved successfully");
    }

  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        !.showSnackBar(new SnackBar(content: new Text(text)));
  }

  void navigateToEmployeeList(){
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new MyEmployeeList()),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 20);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        uploadfile.add(image.path);
        this.image = imageTemp;
        final bytes = imageTemp.readAsBytesSync();
        String ima64= base64Encode(bytes);
        tmpimgArray.add(ima64);


      }
      );

      print("hemant"+image.path.toString());
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }


  // Future chooseImage() async {
  //
  //
  //   await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 70);
  //
  //
  //
  //   if(choosedimage!=null) {
  //     setState(() {
  //
  //       uploadfile.add(choosedimage.path);
  //       final bytes = Io.File(choosedimage.path).readAsBytesSync();
  //
  //       String img64 = base64Encode(bytes);
  //       print(img64);
  //
  //       tmpimgArray.add(img64);
  //       // prod_array.add(pname);
  //       // prod_array.add(p2name);
  //
  //
  //     });
  //   }else{
  //     print("image not selected");
  //   }
  // }
}