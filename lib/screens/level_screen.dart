import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
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
        title: const Text('DS Chapter 17'),
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
              'Chapter 17',
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
              'Ballast Barbary Coast red ensign aye rope end transom Plate Fleet mizzenmast chase guns barkadeer. Red ensign Chain Shot league scourge of the seven seas ye chase rope end hempen halter list hearties. Draught warp American Main gibbet careen galleon shrouds fire in the hole prow strike colors. \n\nMizzenmast execution dock strike colors long boat mutiny interloper prow lugger maroon hail-shot. Cat o\'nine tails Arr to go on account long boat yardarm doubloon Sink me belay tackle black jack. Yellow Jack squiffy blow the man down fire in the hole stern hands fathom gun bring a spring upon her cable yo-ho-ho. \n\nAhoy yardarm nipperkin sutler quarterdeck bilge rat strike colors lad coxswain hail-shot. Brethren of the Coast scourge of the seven seas fathom gun yo-ho-ho ho marooned no prey, no pay hornswaggle bowsprit. Sheet handsomely belay marooned parley weigh anchor scurvy prow pirate hempen halter.',
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
              trailing: IconButton(
                icon: Icon(Icons.live_help),
                color: Colors.red[900],
                onPressed: () {},
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
                    'Add a New Note',
                    style: TextStyle(color: Colors.white, fontSize: 12,),
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
                    'Open Image Clue',
                    style: TextStyle(color: Colors.white, fontSize: 12,),
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
