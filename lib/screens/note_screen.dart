import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';

class NoteScreen extends StatefulWidget {
  static const String id = 'note_screen';

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
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
      appBar: AppBar(
        title: const Text('Field Notes'),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .doc(_auth.currentUser.uid)
            .collection('usernotes')
            .snapshots(),
        builder: (ctx, streamSnapShot) {
          if (!streamSnapShot.hasData) return const Text('Loading...');
          if (streamSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final noteData = streamSnapShot.data.docs;
          return ListView.builder(
            itemCount: noteData.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.launch),
                    color: Colors.blueGrey,
                    onPressed: () {},
                  ),
                  title: Text(noteData[index]['title'],
                      style: Theme.of(context).textTheme.headline6),
                  subtitle: Text(noteData[index]['text'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('notes')
                .doc(_auth.currentUser.uid)
                .collection('usernotes')
                .add({
              'title': 'Chapter 11',
              'text': 'This was added by clicking the button!',
            });
          }),
    );
  }
}
