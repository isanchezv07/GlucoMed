// ignore_for_file: unnecessary_new

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Gluco Med',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage()
    );
  }
}