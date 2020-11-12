import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darker_slate/screens/messages_screen.dart';
import 'package:darker_slate/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class MessageDetailScreen extends StatefulWidget {
  final DocumentSnapshot message;
  MessageDetailScreen({this.message});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.message.data()['subject']),
          actions: <Widget>[
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
          child: Column(children: [
            Html(
              data: widget.message.data()['text'],
              style: {
                //Alternatively, apply a style from an existing TextStyle:
                "p": Style.fromTextStyle(
                  TextStyle(fontSize: 16,),
                ),
              },
            ),
            //Text(widget.message.data()['text']),
          ],),
        ),
      ),
    ));
  }
}
