import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostelchat/chatctrl.dart';
import 'package:hostelchat/chatpage.dart';
import 'package:hostelchat/main.dart';
import 'package:hostelchat/updatespage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(36, 105, 240, 175),
        leading: null,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const AuthenticationWrapper()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: h * 0.2),
        child: Column(
          children: [
            const Center(
              child: Text('Get connected with your fellow hostel members'),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) =>
                          ChatPage(chatController: ChatController()))));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(36, 105, 240, 175),
                    padding: EdgeInsets.symmetric(horizontal: w * 0.24)),
                child: const Text('CHAT'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const UpdatesPage())));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(36, 105, 240, 175),
                    padding: EdgeInsets.symmetric(horizontal: w * 0.21)),
                child: const Text('UPDATES'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
