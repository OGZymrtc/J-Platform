import 'package:flutter/material.dart';
import 'package:jplatform/screens/login_activity.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen() ,
    );
  }
}
