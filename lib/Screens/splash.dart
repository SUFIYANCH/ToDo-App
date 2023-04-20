import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/Screens/home.dart';
import 'package:todo_app/Screens/login.dart';
import 'package:todo_app/constants/Colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    gotoHome();
  }

  gotoHome() async {
    await Future.delayed(
        const Duration(seconds: 3),
        (() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => _isSignedIn ? Home() : LoginScreen()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
                "https://assets7.lottiefiles.com/packages/lf20_p9e3k0ln.json"),
            const SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(
                  text: "T",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800]),
                  children: const [
                    TextSpan(
                      text: "o",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: tdBlack),
                    ),
                    TextSpan(text: "D"),
                    TextSpan(
                      text: "o",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: tdBlack),
                    ),
                    TextSpan(
                      text: " App",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
