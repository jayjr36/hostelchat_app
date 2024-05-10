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
        padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: h * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to our Hostel \n    Management App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: h * 0.1,
            ),
            const Center(
              child: Text(
                'Here, you can connect with fellow hostel \n     members, share updates, and stay \n        updated with all the happenings \n                   within our community. \nWhether you\'re looking for a friendly chat \n    or need to be informed about important \n         announcements, you\'re in the right \n                                  place.',
                style: TextStyle(fontSize: 16),
              ),
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
