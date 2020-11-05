import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String username;
  String password;
  int userLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.blueGrey[400],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(children: <Widget>[
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
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value.trim();
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Enter your email'),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        username = value.trim();
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          prefixIcon: Icon(Icons.account_circle),
                          hintText: 'Enter a username'),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value.trim();
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
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
                                if (newUser != null) {
                                  Navigator.pushNamed(context, LevelScreen.id);
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(newUser.user.uid)
                                    .set({
                                  'username': username,
                                  'email': email,
                                  'userLevel': userLevel,
                                });
                              } on PlatformException catch (e) {
                                var message =
                                    'An error occurred, please check your credentials!';

                                if (e.message != null) {
                                  message = e.message;
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(message),
                                  duration: Duration(seconds: 3),
                                ));
                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                print(e);
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
