import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("الإعدادات"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepPurple),
            title: const Text(
              "تعديل الملف الشخصي",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(Icons.lock, color: Colors.deepPurple),
            title: const Text(
              "الخصوصية",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(Icons.notifications,
                color: Colors.deepPurple),
            title: const Text(
              "الإشعارات",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(Icons.dark_mode,
                color: Colors.deepPurple),
            title: const Text(
              "الوضع الليلي",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(Icons.logout,
                color: Colors.red),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
