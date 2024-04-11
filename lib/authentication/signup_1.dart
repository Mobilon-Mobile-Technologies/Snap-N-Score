import 'package:flutter/material.dart';
import 'package:qr_scanner/authentication/signup_2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage1 extends StatefulWidget {
  const SignupPage1({super.key});

  @override
  State<SignupPage1> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage1> {
  final supabase = Supabase.instance.client;
  final _formkey = GlobalKey<FormState>();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _enrollno=TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _selectedYear = 1;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup Page"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: LinearProgressIndicator(
            value: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.05, left: height * 0.02, right: height * 0.02),
          child: Column(
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _firstname,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "First Name"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Empty field";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _lastname,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Last Name"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Empty field";
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _enrollno,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Enrollment Number",
                              helperText: "Eg:E30CSEU1269",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Email";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "University Email",
                        helperText: "ABC@bennett.edu.in",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        } else if (!value.contains("bennett.edu.in")) {
                          return "Enter a valid University Email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Enter Password",
                        helperText: "ABC@gmail.com",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Select your current year",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 5,
              ),
              SegmentedButton(
                emptySelectionAllowed: false,
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.all(7))),
                segments: const [
                  ButtonSegment(value: 1, label: Text("year 1")),
                  ButtonSegment(value: 2, label: Text("year 2")),
                  ButtonSegment(value: 3, label: Text("year 3")),
                  ButtonSegment(value: 4, label: Text("year 4")),
                ],
                selected: {_selectedYear},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedYear = newSelection.first;
                  });
                },
              ),
              SizedBox(
                height: height * 0.05,
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.navigate_next_rounded),
                label: const Text("next"),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    final name = "${_firstname.text}${_lastname.text}";
                    final enrollno=_enrollno.text;
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    final year = _selectedYear.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignupPage2(name, enrollno, email, password, year),
                        ));
                  }
                },
                style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll<Size>(
                        Size(height * 0.5, height * 0.068)),
                    overlayColor: const MaterialStatePropertyAll(Colors.amber)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
