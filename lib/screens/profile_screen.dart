import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darker_slate/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'messages_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  int _userCurrentLevel;

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
        title: Text('My Profile'),
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
      body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red[900],
                ),
              );
            }
            _userCurrentLevel = snapshot.data['userlevel'];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Column(
                      children: [
                        SizedBox(height: 16),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(snapshot.data['image_url']),
                          backgroundColor: Colors.transparent,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data['username'],
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Text('Level: ${_userCurrentLevel}',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16.0,
                            )),
                      ],
                    ),
                  ]),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24,
                      ),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    '${snapshot.data['username']}\'s Stats',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              leading: Icon(Icons.emoji_events),
                              title: Text('Successful Guesses: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              trailing:
                                  Text(snapshot.data['successes'].toString(),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      )),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.thumb_down_alt),
                              title: Text('Failed Guesses: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              trailing: Text(snapshot.data['fails'].toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  )),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.double_arrow),
                              title: Text('Levels Skipped: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              trailing:
                                  Text(snapshot.data['levelskips'].toString(),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      )),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.help_center),
                              title: Text('Hints Taken: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              trailing:
                                  Text(snapshot.data['hints_taken'].toString(),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
