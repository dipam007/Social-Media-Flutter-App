import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'package:social_media_app/signin.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  final _color = TextEditingController();

  String dropdownValue = 'One';

  CollectionReference appbarColor = Firestore.instance.collection('AppbarColorCode');

  @override
  void initState() {
    super.initState();
    InternetConnectivity(context: context).checkInternetConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> addAppbarColor(String colorcode) {
    if(_color.text!=null) {
      return appbarColor.document('tPIdj7SrX1d9X83bzcEA').updateData({
        "color_code": colorcode
      }).then((result){
        print("Color code Successfully Updated************");
      }).catchError((err){
        print("Failed to Update color code: $err");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
              child: TextFormField(
                controller: _color,
                decoration: InputDecoration(
                  hintText: "Enter Color Name",
                  prefixIcon: Icon(
                    Icons.color_lens,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            // DropdownButton<String>(
            //     value: dropdownValue,
            //     icon: const Icon(Icons.arrow_downward),
            //     iconSize: 24,
            //     elevation: 16,
            //     style: const TextStyle(color: Colors.deepPurple),
            //     underline: Container(
            //       height: 2,
            //       color: Colors.deepPurpleAccent,
            //     ),
            //     onChanged: (String newValue) {
            //       setState(() {
            //         dropdownValue = newValue;
            //       });
            //     },
            //     items: <String>['One', 'Two', 'Three', 'Four']
            //         .map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            //   ),
            // OutlinedButton(
            //     child: Text("Change Design"),
            //     onPressed: () async{
            //       SharedPreferences preferences = await SharedPreferences.getInstance();
            //       preferences.setString('color', _color.text.toString());
            //       preferences.setString('buttomNavigationBar', dropdownValue);
            //     },
            // ),
            OutlinedButton(
                child: Text("Change AppbarColor"),
                onPressed: () {
                  addAppbarColor(_color.text);
                    }
                  ),
                  OutlinedButton(
                  child: Text("Sign In"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));
              },
            )
          ],
        ),
      ),
    );
  }
}

