import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';
import 'level_screen.dart';
import '../widgets/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[400],
      body: Stack(children: <Widget>[
        Image(
          image: AssetImage("assets/images/background3.jpg"),
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          fit: BoxFit.cover,
        ),
        Padding(
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
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 12.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_left, color: Colors.red[900]),
                          Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RoundedButton(
                      title: 'Register',
                      colour: Colors.red[900],
                      onPressed: () async {
                        try {
                          final newUser = await _auth
                              .createUserWithEmailAndPassword(
                              email: email, password: password);
                          if (newUser != null) {
                            Navigator.pushNamed(context, LevelScreen.id);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
