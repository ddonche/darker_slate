import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import 'level_detail_screen.dart';
import 'messages_screen.dart';

class LevelProgressScreen extends StatefulWidget {
  static const String id = 'level_progress_screen';

  @override
  _LevelProgressScreenState createState() => _LevelProgressScreenState();
}

class _LevelProgressScreenState extends State<LevelProgressScreen> {
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

  Future getLevels() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('levels')
        .where('level', isLessThanOrEqualTo: _userCurrentLevel)
        .orderBy('level', descending: true)
        .get();

    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot level) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LevelDetailScreen(level: level,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Story Progress'),
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
            return Container(child: FutureBuilder(
                future: getLevels(),
                builder: (_, snapshot2) {
                  if(snapshot2.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text('Loading levels...'),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot2.data.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Card(
                              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(snapshot2.data[index].data()['image']),
                                  backgroundColor: Colors.transparent,
                                ),
                                title: Text(snapshot2.data[index].data()['title']),
                                subtitle: Text(snapshot2.data[index].data()['subtitle']),
                                onTap: () => navigateToDetail(snapshot2.data[index]),
                              ),
                            ),
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
