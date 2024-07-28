// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:qr_scanner/authentication/signup_1.dart';
import 'package:qr_scanner/bottomNav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  final _formkey = GlobalKey<FormState>();
  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignupPage1()));
              },
              child: const Text("Sign Up"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _EmailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Email"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  TextFormField(
                    controller: _PasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter password";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            OutlinedButton(
              onPressed: () async {
                if(_formkey.currentState!.validate()){
                  final sm = ScaffoldMessenger.of(context);
                  await supabase.auth
                      .signInWithPassword(
                          password: _PasswordController.text,
                          email: _EmailController.text)
                      .then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: ((context) => const BottomNavBar())));
                  }).onError((error, stackTrace) {
                    sm.showSnackBar(SnackBar(content: Text("$error")));
                  });
                }
              },
              style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll<Size>(
                      Size(height * 0.5, height * 0.068)),
                  overlayColor: const MaterialStatePropertyAll(Colors.greenAccent)),
              child: const Text("login"),
            ),
          ],
        ),
      ),
    );
  }
}