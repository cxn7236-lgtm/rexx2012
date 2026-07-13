import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/settings_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    SearchScreen(),
    UploadScreen(),
    NotificationsScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "بحث",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "رفع",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "إشعارات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: "رسائل",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "حسابي",
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.grey.shade900,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "@rex_user",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.deepPurple),
              title: const Text(
                "الإعدادات",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.deepPurple),
              title: const Text(
                "المساعدة",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.deepPurple),
              title: const Text(
                "حول التطبيق",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
