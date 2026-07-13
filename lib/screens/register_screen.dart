import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("إنشاء حساب"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            const Icon(
              Icons.local_fire_department,
              color: Colors.deepPurple,
              size: 90,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: username,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "اسم المستخدم",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: email,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "البريد الإلكتروني",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: password,
              obscureText: hidePassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "كلمة المرور",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("سيتم إنشاء الحساب لاحقًا"),
                  ),
                );
              },
              child: const Text("إنشاء حساب"),
            ),
          ],
        ),
      ),
    );
  }
}
