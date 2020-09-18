import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jplatform/screens/notification_activity.dart';
import 'package:jplatform/utilities/constants.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

TextEditingController userNameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlue[600],
                  Colors.lightBlue[700],
                  Colors.lightBlue[800],
                  Colors.lightBlue[900],
                  /*Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),*/
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/minLogo.png"),
                  ),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildUserNameText(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildPwdText(),
                  _buildLogInButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildUserNameText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'User Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: userNameController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Enter Your User Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  _buildPwdText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            controller: passwordController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter Your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  _buildLogInButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _login(userNameController.text, passwordController.text);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'L O G I N',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  _login(String userNameController, String passwordController) async {
    fetchUser(userNameController, passwordController).then((value) => {
          if (value.success)
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => NotificationActivity(
                          authToken: value.authorization,
                          usrName: userNameController)),
                  (route) => false),
            }
          else
            {Toast.show("Wrong User Name Or Password", context, duration: 3)}
        });
  }

  Future<User> fetchUser(
      String userNameController, String passwordController) async {
    String authorization =
        userNameController + ":" + passwordController + ":1:1:TRTR";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String authEncoded = "BASIC " + stringToBase64.encode(authorization);
    final response = await http.post(
      'http://172.16.1.97:8090/logo/restservices/rest/login',
      headers: {
        HttpHeaders.authorizationHeader: authEncoded,
      },
    );
    final responseJson = json.decode(response.body);
    return User.fromJson(responseJson);
  }
}

class User {
  String authorization;
  bool success;

  User({this.authorization, this.success});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      authorization: json['authToken'],
      success: json['success'],
    );
  }
}
