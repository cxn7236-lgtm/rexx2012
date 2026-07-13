import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/navigation_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const RexApp());
}


class RexApp extends StatelessWidget {
  const RexApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "REX",

      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
      ),

      home: const NavigationScreen(),
    );
  }
}
