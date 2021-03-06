import 'package:darker_slate/screens/account_settings_screen.dart';
import 'package:darker_slate/screens/leaderboard_screen.dart';
import 'package:darker_slate/screens/level_progress_screen.dart';
import 'package:darker_slate/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/level_screen.dart';
import 'screens/note_screen.dart';
import 'screens/messages_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DarkerSlate());
}

class DarkerSlate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Vollkorn',
        primaryColor: Colors.red[900],
        accentColor: Colors.blueGrey,
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'Vollkorn',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        AccountSettingsScreen.id : (context) => AccountSettingsScreen(),
        LevelScreen.id : (context) => LevelScreen(),
        NoteScreen.id : (context) => NoteScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        WelcomeScreen.id : (context) => WelcomeScreen(),
        MessagesScreen.id: (context) => MessagesScreen(),
        LevelProgressScreen.id : (context) => LevelProgressScreen(),
        ProfileScreen.id : (context) => ProfileScreen(),
        LeaderboardScreen.id : (context) => LeaderboardScreen(),
      },
    );
  }
}
