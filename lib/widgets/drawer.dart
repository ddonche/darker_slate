import 'package:flutter/material.dart';
import '../screens/note_screen.dart';

class AppDrawer extends StatelessWidget {

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:  AssetImage('assets/images/background2.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Resources",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
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
          _createDrawerItem(icon: Icons.account_circle, text: 'Profile',),
          _createDrawerItem(icon: Icons.monetization_on, text: 'Credits',),
          _createDrawerItem(icon: Icons.settings, text: 'Account Settings',),
          Divider(),
          _createDrawerItem(icon: Icons.book, text: 'Story Progress',),
          _createDrawerItem(icon: Icons.description, text: 'Field Notes', onTap: () {
            Navigator.pushNamed(context, NoteScreen.id);
          },),
          _createDrawerItem(icon: Icons.chat, text: 'Messages'),
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