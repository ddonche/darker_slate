import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../screens/registration_screen.dart';
import '../screens/login_screen.dart';
import '../widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[400],
      body: Stack(children: <Widget>[
        Image(
          image: AssetImage("assets/images/background.jpg"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('assets/images/logo.png'),
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['Darker Slate'],
                    textStyle: TextStyle(
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Vollkorn',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              RoundedButton(title: 'Login', colour: Colors.blueGrey, onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },),
              RoundedButton(title: 'Register', colour: Colors.red[900], onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },),
            ],
          ),
        ),
      ]),
    );
  }
}
