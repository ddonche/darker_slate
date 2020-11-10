import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;

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

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
              ),
            ),
          ),
        );
      },
    );
  }
}
