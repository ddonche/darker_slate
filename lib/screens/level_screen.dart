import 'package:darker_slate/screens/messages_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
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
  ScrollController _scrollController = ScrollController();
  String _levelSolution;
  String _levelImage;
  String _imageCaption;
  int _userHints;
  int _userCredits;
  static AudioCache player = new AudioCache();
  static const incorrectAudio = "incorrect.mp3";
  static const correctAudio = "correct.mp3";
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
      //isScrollControlled: true,
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
      isScrollControlled: true,
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.99,
            decoration: new BoxDecoration(
              color: Colors.transparent,
              // borderRadius: new BorderRadius.only(
              //   topLeft: const Radius.circular(25.0),
              //   topRight: const Radius.circular(25.0),
              // ),
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
                          child: Image.network(_levelImage),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_imageCaption),
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

  void _submitGuess() async {
    // obtain users's current level
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get();
    String thisLevel = ds['userlevel'].toString();
    print(thisLevel);

    if (_guessController.text.isEmpty) {
      return;
    }
    final enteredGuess = _guessController.text.trim();

    // incorrect guess
    if (enteredGuess != _levelSolution) {
      FirebaseFirestore.instance
          .collection('levels')
          .doc(thisLevel)
          .update({'fails': FieldValue.increment(1)});
      player.play(incorrectAudio);
      clearTextInput();
    }
    // correct guess
    else if (enteredGuess == _levelSolution) {
      var firebaseUser = FirebaseAuth.instance.currentUser;

      FirebaseFirestore.instance
          .collection('levels')
          .doc(thisLevel)
          .update({'solves': FieldValue.increment(1)});

      player.play(correctAudio);

      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update({
        'userlevel': FieldValue.increment(1),
        'credits': FieldValue.increment(3),
        'hints': 3,
      });
      clearTextInput();
    }

    Navigator.of(context).pop();
  }

  final _guessController = TextEditingController();

  clearTextInput() {
    _guessController.clear();
  }

  void _solveLevel(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Your Solution',
                    prefixIcon: Icon(Icons.vpn_key),
                  ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(),
                                  icon: Icon(Icons.help_center),
                                  color: (_userHints > 0 && _userCredits >= 5)
                                      ? Colors.red[900]
                                      : Colors.grey,
                                  onPressed: () {
                                    if (_userHints > 0 && _userCredits >= 5) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_auth.currentUser.uid)
                                          .update({
                                        'hints': FieldValue.increment(-1),
                                        'hints_taken': FieldValue.increment(1),
                                        'credits': FieldValue.increment(-5)
                                      });
                                      Navigator.pop(context);
                                      _scrollController.animateTo(
                                          _scrollController.position.maxScrollExtent,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    } else {
                                      return;
                                    }
                                  },
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
                              color: Theme.of(context).primaryColor,
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
                                  color: (_userCredits > 30)
                                      ? Colors.red[900]
                                      : Colors.grey,
                                  onPressed: () {
                                    if (_userCredits >= 30) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_auth.currentUser.uid)
                                          .update({
                                        'userlevel': FieldValue.increment(1),
                                        'credits': FieldValue.increment(-30),
                                        'levelskips': FieldValue.increment(1),
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      return;
                                    }
                                  },
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
                                    '(30 Credits)',
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
            _userHints = snapshot.data['hints'];
            _userCredits = snapshot.data['credits'];
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
                  _levelImage = snapshot2.data['image'];
                  _imageCaption = snapshot2.data['image_caption'];
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Container(
                          //color: Colors.black,
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    OutlineButton(
                                      onPressed: () {},
                                      shape: new CircleBorder(),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 3),
                                      child: Icon(
                                        Icons.emoji_events,
                                        color: Colors.green,
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
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.blueGrey,
                                ),
                                Column(
                                  children: <Widget>[
                                    OutlineButton(
                                      onPressed: () {},
                                      shape: new CircleBorder(),
                                      borderSide: BorderSide(
                                          color: Colors.orange, width: 3),
                                      child: Icon(
                                        Icons.local_fire_department,
                                        color: Colors.orange,
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
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.blueGrey,
                                ),
                                Column(
                                  children: <Widget>[
                                    OutlineButton(
                                      onPressed: () {},
                                      shape: new CircleBorder(),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 3),
                                      child: Icon(
                                        Icons.thumb_down_alt,
                                        color: Colors.red,
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
                                        fontSize: 12,
                                        color: Colors.black,
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
                        color: Colors.blueGrey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.monetization_on),
                            color: Colors.amber,
                            onPressed: () {},
                          ),
                          Text(
                            '${snapshot.data['credits'].toString()} credits',
                          ),
                          SizedBox(width: 40),
                          IconButton(
                            icon: Icon(Icons.get_app),
                            color: Colors.red[900],
                            onPressed: () {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                          ),
                          Text(
                            '${snapshot.data['hints'].toString()} hints left',
                          ),
                        ],
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        snapshot2.data['title'].toString(),
                        style: TextStyle(
                          fontFamily: 'Vollkorn',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          snapshot2.data['subtitle'].toString(),
                          style: TextStyle(
                            fontFamily: 'Vollkorn',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 40,
                        ),
                        child: Html(
                          data: snapshot2.data['text'],
                          style: {
                            //Alternatively, apply a style from an existing TextStyle:
                            "p": Style.fromTextStyle(
                              TextStyle(fontFamily: 'Vollkorn', fontSize: 18),
                            ),
                          },
                        ),
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      if (_userHints == 3)
                        Text('You haven\'t used any hints yet.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blueGrey,
                            )),
                      if (_userHints <= 2)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Hints:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              )),
                        ),
                      if (_userHints <= 2)
                        Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.red[900]),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot2.data['hint1'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_userHints <= 1)
                        Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.red[900]),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot2.data['hint2'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_userHints == 0)
                        Card(
                          elevation: 3,
                          margin:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.red[900]),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot2.data['hint3'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_userHints == 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('You are out of hints for this level.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.red[900],
                              )),
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
