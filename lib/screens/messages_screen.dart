import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final chats = [
      {
        "name": "Ahmed",
        "message": "مرحباً 👋",
        "time": "10:30"
      },
      {
        "name": "Sara",
        "message": "كيف حالك؟",
        "time": "09:45"
      },
      {
        "name": "Mohamed",
        "message": "شاهدت فيديوك 🔥",
        "time": "أمس"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("الرسائل"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              chats[index]["name"]!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              chats[index]["message"]!,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              chats[index]["time"]!,
              style: const TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
