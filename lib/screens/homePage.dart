// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class homePage extends StatefulWidget {
  const homePage({super.key, this.mybool});
  final mybool;

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final random = Random();
  final supabase = Supabase.instance.client;
  int currentIndex = 0;
  List courses = [];
  List attendance = ["0", "0", "0", "0", "0", "0"];

  @override
  void initState() {
    super.initState();
    getdata().then((_) async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<Color>> gradients = [
      [Color(0xFFffafbd), Color(0xFFffc3a0)],
      [Color(0xFF2193b0), Color(0xFF6dd5ed)],
      [Color(0xFF2193b0), Color(0xFF6dd5ed)],
      [Color(0xFFcc2b5e), Color(0xFF753a88)],
      [Color(0xFFee9ca7), Color(0xFFffdde1)],
      [Color(0xFF42275a), Color(0xFF734b6d)],
      [Color(0xFFde6262), Color(0xFFffb88c)],
      [Color(0xFF06beb6), Color(0xFF48b1bf)],
      [Color(0xFFdd5e89), Color(0xFFf7bb97)],
      [Color(0xFF614385), Color(0xFF516395)],
      [Color(0xFFeecda3), Color(0xFFef629f)],
      [Color(0xFFeacda3), Color(0xFFd6ae7b)],
      [Color(0xFFddd6f3), Color(0xFFfaaca8)],
      [Color(0xFF43cea2), Color(0xFF185a9d)],
      [Color(0xFFba5370), Color(0xFFf4e2d8)],
      [Color(0xFFffd89b), Color(0xFF19547b)],
      [Color(0xFF4ca1af), Color(0xFFc4e0e5)],
      [Color(0xFFff5f6d), Color(0xFFffc371)],
    ];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ninety Percent Club'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // welcome back message
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: width * 0.7,
                height: height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.pink[50],
                ),
                child: Center(
                  child: Text(
                    "Welcome back, ${supabase.auth.currentUser?.userMetadata?['name']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemCount: 5,
                itemBuilder: (_, index) {
                  if (gradients.isEmpty) {
                    return Container();
                  } else {
                    int gradindex = random.nextInt(gradients.length);
                    List<Color> gradientvar = gradients[gradindex];
                    gradients.removeAt(gradindex);
                    return Container(
                      padding: EdgeInsets.all(height * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        gradient: LinearGradient(colors: gradientvar),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                child: Text(attendance[index] + "%"),
                                radius: height * 0.03,
                                backgroundColor: gradientvar[0],
                              )
                            ],
                          ),
                          Text(
                            courses[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getdata() async {
    final data = await supabase.from('courses').select().eq("semester", "1");

    for (Map<String, dynamic> map in data) {
      map.forEach((key, value) {
        if (key != "semester") {
          courses.add(value);
        }
      });
    }
  }
}
