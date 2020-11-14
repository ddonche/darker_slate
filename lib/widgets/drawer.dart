import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darker_slate/screens/level_progress_screen.dart';
import 'package:darker_slate/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/note_screen.dart';
import '../screens/messages_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/background2.jpg'))),
      child: StreamBuilder<DocumentSnapshot>(
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
            return Stack(children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                  children: [
                    SizedBox(height: 6),
                    CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage(snapshot.data['image_url']),
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              ]),
              Positioned(
                  bottom: 34.0,
                  left: 16.0,
                  child: Text(snapshot.data['username'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500))),
              Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text('Level: ${snapshot.data['userlevel']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ))),
            ]);
          }),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.account_circle,
            text: 'Profile',
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.id);
            },
          ),
          _createDrawerItem(
            icon: Icons.monetization_on,
            text: 'Credits',
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Account Settings',
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.book,
            text: 'Story Progress',
            onTap: () {
              Navigator.pushNamed(context, LevelProgressScreen.id);
            },
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Field Notes',
            onTap: () {
              Navigator.pushNamed(context, NoteScreen.id);
            },
          ),
          _createDrawerItem(
            icon: Icons.chat,
            text: 'Messages',
            onTap: () {
              Navigator.pushNamed(context, MessagesScreen.id);
            },
          ),
          _createDrawerItem(icon: Icons.emoji_events, text: 'Leaderboards'),
          Divider(),
          _createDrawerItem(icon: Icons.send, text: 'Invite a Friend'),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          Divider(),
          ListTile(
            title: Text('Darker Slate v.0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
