import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:todo_app/Screens/home.dart';
import 'package:todo_app/Screens/login.dart';
import 'package:todo_app/Widgets/snackbar.dart';
import 'package:todo_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController reguserController = TextEditingController();
  TextEditingController regemailController = TextEditingController();
  TextEditingController regpasswordController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 220,
                    width: 220,
                    child: Image.asset(
                      "lib/assets/images/register.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Text(
                  //   "Sign up",
                  //   style: GoogleFonts.bebasNeue(fontSize: 52),
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  TextField(
                    controller: reguserController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                        hintText: "Username"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: regemailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        hintText: "Email"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: regpasswordController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        hintText: "Password"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48)),
                    onPressed: (() async {
                      var regemail = regemailController.text;
                      var regpassword = regpasswordController.text;

                      try {
                        await authService
                            .signup(regemail, regpassword)
                            .then((value) => {
                                  log("User created"),
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => const Home()),
                                      (route) => false)
                                });
                      } on FirebaseAuthException catch (e) {
                        showSnackBar(context, e.message);
                      }
                    }),
                    child: const Text("Sign up"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already a member?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => const LoginScreen())));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
