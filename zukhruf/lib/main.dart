import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'dubai',
        ),
        //use MaterialApp() widget like this
        home: Welcome() //create new widget class for this 'home' to
        // escape 'No MediaQuery widget found' error
        );
  }
}
