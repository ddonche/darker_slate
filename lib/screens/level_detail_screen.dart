import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darker_slate/screens/messages_screen.dart';
import 'package:darker_slate/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import 'level_screen.dart';

class LevelDetailScreen extends StatefulWidget {
  final DocumentSnapshot level;

  LevelDetailScreen({this.level});

  @override
  _LevelDetailScreenState createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends State<LevelDetailScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  TransformationController controller = TransformationController();
  String velocity = "VELOCITY";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.level.data()['subtitle']),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () {
                Navigator.pushNamed(context, LevelScreen.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              tooltip: 'Messages',
              onPressed: () {
                Navigator.pushNamed(context, MessagesScreen.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Log Out',
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Html(
                    data: widget.level.data()['text'],
                    style: {
                      //Alternatively, apply a style from an existing TextStyle:
                      "p": Style.fromTextStyle(
                        TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    },
                  ),
                  InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(20.0),
                    minScale: 0.1,
                    maxScale: 2.5,
                    transformationController: controller,
                    child: Image.network(widget.level.data()['image']),
                    onInteractionEnd: (ScaleEndDetails endDetails) {
                      print(endDetails);
                      print(endDetails.velocity);
                      controller.value = Matrix4.identity();
                      setState(() {
                        velocity = endDetails.velocity.toString();

                      });
                    },
                  ),
                  //Image.network(widget.level.data()['image']),
                  //Text(widget.message.data()['text']),
                ],
              ),
            ),
          ),
        ));
  }
}
