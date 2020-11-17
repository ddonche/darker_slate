import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darker_slate/screens/messages_screen.dart';
import 'package:darker_slate/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDetailScreen extends StatefulWidget {
  final DocumentSnapshot message;
  MessageDetailScreen({this.message});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  // open PDF from URL https://www.youtube.com/watch?v=5S9qjreGFNc
  String urlPDFPath = '';

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
            if (widget.message.data()['attachment'] != null)
              Divider(),
            if (widget.message.data()['attachment'] != null)
              RaisedButton.icon(onPressed:() async {
                String url = widget.message.data()['attachment'];
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
                elevation: 2.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                color: Colors.blueGrey,
                icon: Icon(Icons.attachment),
                label: Text(widget.message.data()['attachment_name'],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),),
          ],),
        ),
      ),
    ));
  }
}
