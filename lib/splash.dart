import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:hostelchat/main.dart';
import '../home.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
          'assets/logo.png'),
      title: Text(
        "DAR ES SALAAM INSTITUTE OF TECHNOLOGY",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
      backgroundColor: Colors.yellow.shade800,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator:const AuthenticationWrapper(),
      durationInSeconds: 5,
    );
  }
}