import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/drawer.dart';
import 'welcome_screen.dart';

class LevelScreen extends StatefulWidget {
  static const String id = 'level_screen';

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _levelSolution;
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
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void _startAddNewNote(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          //child: NewNote(_addNewNote),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _startShowImageClue(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.75,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/unknown-caller-screenshot.png',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('the cell phone message'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _submitGuess() {
    if (_guessController.text.isEmpty) {
      return;
    }
    final enteredGuess = _guessController.text.trim();

    if (enteredGuess != _levelSolution) {
      clearTextInput();
      print('You guessed incorrectly!');
    } else if (enteredGuess == _levelSolution) {
      var firebaseUser = FirebaseAuth.instance.currentUser;

      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update({'userlevel': FieldValue.increment(1)});

      clearTextInput();
      print('You got it right!');
    }

    Navigator.of(context).pop();
  }

  final _guessController = TextEditingController();

  clearTextInput(){
    _guessController.clear();
  }

  void _solveLevel(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.55,
              child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Enter Your Solution'),
                        controller: _guessController,
                        onSubmitted: (_) => _submitGuess(),
                        /*onChanged: (val) {
                      titleInput = val;
                    },*/
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.all(2),
                                        constraints: BoxConstraints(),
                                        icon: Icon(Icons.help_center),
                                        color: Colors.red[900],
                                        onPressed: () {},
                                      ),
                                      Text(
                                        'Get Hint',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '(5 Credits)',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  RaisedButton(
                                    child: Text('Solve Level'),
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    textColor: Colors.white,
                                    onPressed: _submitGuess,
                                    //_submitGuess,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.all(2),
                                        constraints: BoxConstraints(),
                                        icon: Icon(Icons.double_arrow),
                                        color: Colors.red[900],
                                        onPressed: () {},
                                      ),
                                      Text(
                                        'Skip Level',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '(50 Credits)',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(16.0),
                              //   child: Divider(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 28.0),
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width * 0.75,
                              //     child: Text(
                              //       'Hint: Use the image clue in the "Show Puzzle" popup to figure out the solution to this level.',
                              //       style: TextStyle(
                              //         fontStyle: FontStyle.italic,
                              //       ),
                              //       textAlign: TextAlign.center,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
    );
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
            return StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('levels')
                    .doc(snapshot.data['userlevel'].toString())
                    .snapshots(),
                builder: (context, snapshot2) {
                  if (!snapshot2.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red[900],
                      ),
                    );
                  }
                  var difficulty = (snapshot2.data['fails'].toDouble() /
                      snapshot2.data['solves'].toDouble());
                  _levelSolution = snapshot2.data['solution'];
                  return SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Container(
                          //color: Colors.black,
                          height: 110,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Ink(
                                      decoration: const ShapeDecoration(
                                        color: Colors.green,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.star),
                                        color: Colors.white,
                                        onPressed: () {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot2.data['solves'].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'solves',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalDivider(),
                                Column(
                                  children: <Widget>[
                                    Ink(
                                      decoration: const ShapeDecoration(
                                        color: Colors.orange,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.local_fire_department),
                                        color: Colors.white,
                                        onPressed: () {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        difficulty.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'difficulty rating',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalDivider(),
                                Column(
                                  children: <Widget>[
                                    Ink(
                                      decoration: const ShapeDecoration(
                                        color: Colors.red,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.star_outline),
                                        color: Colors.white,
                                        onPressed: () {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot2.data['fails'].toString(),
                                        //currentLevelFails.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'fails',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          snapshot2.data['title'].toString(),
                          style: TextStyle(
                            fontFamily: 'Vollkorn',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 40,
                        ),
                        child: SelectableText(
                          snapshot2.data['text'].toString(),
                          style: TextStyle(
                            fontFamily: 'Vollkorn',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      Card(
                        elevation: 5,
                        margin:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        child: ListTile(
                          leading: Text(
                            '1',
                            style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.red[900]),
                          ),
                          title: Text('Hint:',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6),
                          subtitle: Text(
                            'Change your perspective on the issue.',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.help_center),
                                color: Colors.red[900],
                                onPressed: () {},
                                tooltip: 'Get Hint for 5 Credits',
                              ), // icon-1
                              IconButton(
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.double_arrow),
                                color: Colors.red[900],
                                onPressed: () {},
                                tooltip: 'Skip Level for 50 Credits',
                              ), // icon-2
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        margin:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        child: ListTile(
                          leading: Text(
                            '2',
                            style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.red[900]),
                          ),
                          title: Text('Hint:',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6),
                          subtitle: Text(
                            'Have you ever heard of a place called Suoods?',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.help_center),
                                color: Colors.red[900],
                                onPressed: () {},
                                tooltip: 'Get Hint for 5 Credits',
                              ), // icon-1
                              IconButton(
                                padding: EdgeInsets.all(2),
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.double_arrow),
                                color: Colors.red[900],
                                onPressed: () {},
                                tooltip: 'Skip Level for 50 Credits',
                              ), // icon-2
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 36),
                    ]),
                  );
                });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.vpn_key),
        tooltip: 'Solve this Level',
        onPressed: () => _solveLevel(context),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.note_add),
                    color: Colors.white,
                    onPressed: () => _startAddNewNote(context),
                  ),
                  Text(
                    'New Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.image),
                    color: Colors.white,
                    onPressed: () => _startShowImageClue(context),
                  ),
                  Text(
                    'Show Puzzle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
