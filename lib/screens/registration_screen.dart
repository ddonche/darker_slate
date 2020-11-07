import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'level_screen.dart';
import 'login_screen.dart';
import '../screens/welcome_screen.dart';
import '../widgets/rounded_button.dart';
import '../widgets/auth_form.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String username;
  String password;
  int userLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Image(
          image: AssetImage("assets/images/background3.jpg"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 140.0,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          },
                          child: Image.asset('assets/images/logo.png')),
                    ),
                  ),
                  SizedBox(
                    height: 28.0,
                  ),
                  AuthForm(),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
