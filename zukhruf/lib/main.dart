import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zukhruf/main_page.dart';
import './welcome.dart';
import './main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBQNzMRgbWuVDm-42Ag96rsvJNWtjR8z8I",
        appId: "1:1096330877405:android:325d0a9f355ea59391be34",
        messagingSenderId: "1096330877405",
        projectId: "zukhruf-93612",
        storageBucket: 'gs://zukhruf-93612.appspot.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'dubai',
        ),
        //use MaterialApp() widget like this
        home: MainPage() //create new widget class for this 'home' to
        // escape 'No MediaQuery widget found' error
        );
  }
}
