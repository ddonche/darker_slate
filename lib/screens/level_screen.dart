import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/drawer.dart';
import 'welcome_screen.dart';

// import '../widgets/rounded_button.dart';

class LevelScreen extends StatefulWidget {
  static const String id = 'level_screen';

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  var userCurrentLevel;
  var currentLevelText;
  var currentLevelTitle;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);

        // obtain users's current level
        DocumentSnapshot ds = await FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.uid)
            .get();
        userCurrentLevel = ds['userLevel'].toString();
        print(userCurrentLevel);

        // obtain current level text
        DocumentSnapshot ds2 = await FirebaseFirestore.instance
            .collection('levels')
            .doc(userCurrentLevel)
            .get();
        currentLevelText = ds2['text'];
        currentLevelTitle = ds2['title'];
        print(currentLevelTitle);
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
            height: MediaQuery.of(context).size.height * 0.75,
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

  void _solveLevel(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(currentLevelTitle.toString()),
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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 100,
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
                          '476',
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
                          '8.3',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                          '3976',
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
          Divider(
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              currentLevelTitle.toString(),
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
              //'Ballast Barbary Coast red ensign aye rope end transom Plate Fleet mizzenmast chase guns barkadeer. Red ensign Chain Shot league scourge of the seven seas ye chase rope end hempen halter list hearties. Draught warp American Main gibbet careen galleon shrouds fire in the hole prow strike colors. \n\nMizzenmast execution dock strike colors long boat mutiny interloper prow lugger maroon hail-shot. Cat o\'nine tails Arr to go on account long boat yardarm doubloon Sink me belay tackle black jack. Yellow Jack squiffy blow the man down fire in the hole stern hands fathom gun bring a spring upon her cable yo-ho-ho. \n\nAhoy yardarm nipperkin sutler quarterdeck bilge rat strike colors lad coxswain hail-shot. Brethren of the Coast scourge of the seven seas fathom gun yo-ho-ho ho marooned no prey, no pay hornswaggle bowsprit. Sheet handsomely belay marooned parley weigh anchor scurvy prow pirate hempen halter.',
              currentLevelText.toString(),
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
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            child: ListTile(
              leading: Text(
                '1',
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.red[900]),
              ),
              title:
                  Text('Hint:', style: Theme.of(context).textTheme.headline6),
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
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            child: ListTile(
              leading: Text(
                '2',
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.red[900]),
              ),
              title:
                  Text('Hint:', style: Theme.of(context).textTheme.headline6),
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
      ),
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
