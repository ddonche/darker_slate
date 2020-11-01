import 'package:darker_slate/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'registration_screen.dart';
import 'welcome_screen.dart';
import '../widgets/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[400],
      body: Stack(children: <Widget>[
          Image(
            image: AssetImage("assets/images/background2.jpg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                      onTap: () {Navigator.pushNamed(context, WelcomeScreen.id);},
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
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 12.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_left, color: Colors.red[900]),
                            Text(
                              'Register',
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
                      title: 'Login',
                      colour: Colors.blueGrey,
                      onPressed: () {},
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
