import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import 'message_detail_screen.dart';

class MessagesScreen extends StatefulWidget {
  static const String id = 'messages_screen';

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
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

  Future getMessages() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('messages')
        .where('level', isLessThanOrEqualTo: _userCurrentLevel)
        .orderBy('level', descending: true)
        .get();

    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot message) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MessageDetailScreen(message: message,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Darker Slate'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chat),
            tooltip: 'Messages',
            onPressed: () {},
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
            return Container(child: FutureBuilder(
              future: getMessages(),
              builder: (_, snapshot2) {
                if(snapshot2.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text('Loading messages...'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot2.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('From: ${snapshot2.data[index].data()['from']}'),
                          subtitle: Text('Subject: ${snapshot2.data[index].data()['subject']}'),
                          onTap: () => navigateToDetail(snapshot2.data[index]),
                        );
                      }
                  );
                }
              }
            ),);
          }),
    );
  }
}
