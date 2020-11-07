import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../screens/welcome_screen.dart';
import '../widgets/auth_form.dart';
import 'level_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  String _error;

  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    // BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (authResult != null) {
          Navigator.pushNamed(context, LevelScreen.id);
        }
      } else {
        int userLevel = 1;
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': userName,
          'email': email,
          'userlevel': userLevel,
        });

        await FirebaseFirestore.instance
            .collection('notes')
            .doc(authResult.user.uid)
            .collection('usernotes')
            .doc('first note')
            .set({
          'title': 'About Field Notes',
          'text': 'You can add field notes to help you organize ideas or remember things. '
              'This will help you keep track of important clues and other things you wish to save for later.',
        });
      }

    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
        _error = err.message;
      });
    }
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amber,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.error_outline),
          ),
          Expanded(child: Text(_error, maxLines: 3,),),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _error = null;
                });
              },
            ),
          ),
        ],),
      );
    }
    return SizedBox(height: 0);
  }

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
                  showAlert(),
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
                  AuthForm(
                    _submitAuthForm,
                    _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
