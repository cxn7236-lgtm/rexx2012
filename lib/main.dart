import 'package:flutter/material.dart';

void main() {
  runApp(const RexApp());
}

class RexApp extends StatelessWidget {
  const RexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'REX',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REX"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "مرحبًا بك في REX 🔥",
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
