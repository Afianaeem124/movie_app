import "package:flutter/material.dart";
import "package:imdb_clone/screens/home.dart";
import 'package:imdb_clone/screens/mediainfo.dart';
import 'package:imdb_clone/screens/profile.dart';
import 'package:imdb_clone/screens/search.dart';
import "package:imdb_clone/screens/signin.dart";
import "package:imdb_clone/screens/signup.dart";

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'selectscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "IMDB Clone",
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/signup",
      routes: {
        "/": (context) => const SignIn(),
        "/home": (context) => const HomeScreen(),
        "/signin": (context) => const SignIn(),
        "/signup": (context) => const SignUp(),
        "/search": (context) => const SearchScreen(),
        "/profile": (context) => const ProfilePage(
              data: {},
            ),
        "/screens": (context) => const ScreenSelect(),
        "/mediainfo": (context) => const MediaInfo()
      },
    );
  }
}
