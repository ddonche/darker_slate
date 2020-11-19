import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import 'level_detail_screen.dart';
import 'level_screen.dart';
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LevelDetailScreen(
                  level: level,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Story Progress'),
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
            return Container(
              child: FutureBuilder(
                  future: getLevels(),
                  builder: (_, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text('Loading levels...'),
                      );
                    } else {
                      return Center(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            child: Image.network(
                                                snapshot2.data[index].data()['image'],
                                            ),
                                            onTap: () => navigateToDetail(snapshot2.data[index]),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                          child: Text(
                                            snapshot2.data[index].data()['title'],
                                            style:
                                                TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            snapshot2.data[index].data()['subtitle'],
                                            style:
                                            TextStyle(fontSize: 10,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          },
                          itemCount: snapshot2.data.length,
                          //snapshot2.data.length,
                          //itemBuilder: (context, index) {
                          //   return Card(
                          //     margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                          //     elevation: 3,
                          //     child: ListTile(
                          //       leading: CircleAvatar(
                          //         radius: 24,
                          //         backgroundImage: NetworkImage(snapshot2.data[index].data()['image']),
                          //         backgroundColor: Colors.transparent,
                          //       ),
                          //       title: Text(snapshot2.data[index].data()['title']),
                          //       subtitle: Text(snapshot2.data[index].data()['subtitle']),
                          //       onTap: () => navigateToDetail(snapshot2.data[index]),
                          //     ),
                          //   );
                        ),
                      );
                    }
                  }),
            );
          }),
    );
  }
}
