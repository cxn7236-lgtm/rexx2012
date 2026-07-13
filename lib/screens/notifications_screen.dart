import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "أحمد أعجب بفيديوك ❤️",
        "time": "منذ دقيقة"
      },
      {
        "title": "سارة بدأت بمتابعتك 👤",
        "time": "منذ 10 دقائق"
      },
      {
        "title": "محمد علّق على فيديوك 💬",
        "time": "منذ ساعة"
      },
      {
        "title": "وصل فيديوك إلى 1000 مشاهدة 🎉",
        "time": "اليوم"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("الإشعارات"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
            title: Text(
              notifications[index]["title"]!,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              notifications[index]["time"]!,
              style: const TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
