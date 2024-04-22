// ignore_for_file: prefer_const_constructors


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List attendance=[];
  bool showAttendanceDetails = true;
  final List courseId=[];
  final List facultyId=[];
  final List keyId=[];

  @override
  void initState() {
    super.initState();
    getdata().then((_) async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    getAttendancedetails();
    List<List<Color>> gradients = [
      [Color(0xFFcc2b5e), Color(0xFF753a88)],
      [Color(0xFFde6262), Color(0xFFffb88c)],
      [Color(0xFF614385), Color(0xFF516395)],
      [Color(0xFF43cea2), Color(0xFF185a9d)],
      [Color(0xFF4ca1af), Color(0xFFc4e0e5)],
      [Color(0xFFff5f6d), Color(0xFFffc371)],
    ];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Snap n' Score"),
      ),
      body: Stack(children: [
        SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  itemCount: courses.length,
                  itemBuilder: (_, index) {
                    if (courses.isEmpty) {
                      return Container();
                    } else {
                      return Container(
                        padding: EdgeInsets.all(height * 0.02),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            gradient: LinearGradient(
                              colors: gradients[index],
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // upar jo gol jagah hai uska row
                                GestureDetector(
                                  onTap: () => setState(() =>
                                      showAttendanceDetails =
                                          !showAttendanceDetails),
                                  child: showAttendanceDetails
                                      ? Container(
                                          height: height * 0.06,
                                          width: height * 0.06,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: gradients[index][0]),
                                          child: Center(
                                              child: Text(
                                            "${(attendance[index]).toString()}%",
                                            style: TextStyle(fontSize: 18),
                                          )),
                                        )
                                      : Container(
                                          height: height * 0.06,
                                          width: height * 0.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: gradients[index][0],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "0/0",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                ),
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
        if (courses.isEmpty)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
    );
  }

  Future getdata() async {
    final getcourses = await supabase
        .from('user_courses')
        .select('*, courses2!inner(*)')
        .eq('user_id', supabase.auth.currentUser?.userMetadata?['user_id']);
    print("Courses: $getcourses");

    if (getcourses != null && getcourses.isNotEmpty) {
      for (var course in getcourses) {
        courses.add(course['courses2']['course_name']);
      }
    }
  }

  void getAttendancedetails() async {
    // basic visualisation of attendance
    for (int i = 0; i < courses.length; i++) {
     int num = random.nextInt(100);
     attendance.add(num);
    }
    
    print(courses[0]);
    //finding course id from courses2 table

    for(String name in courses) {
    final courseId_Db=await supabase.from('courses2').select('course_id').eq('course_name',name); 
    // storing courseID
    courseId.add(courseId_Db[0]['course_id']);
    }
    
    // finding faculty linked with the course using course id
    for(int id in courseId){
      final faculty=await supabase.from('faculty').select('faculty_id').eq('course_id',id);
      print("Faculty: $faculty");
      facultyId.add(faculty[0]['faculty_id']);
    }
    
    // finding the total keys generated by the faculty
    for(int id in facultyId){
      final keys=await supabase.from('keys_table').select('key_id').eq('faculty_id',id);
      if( keys.isNotEmpty){
        keyId.add(keys[0]['key_id']);
      }
      else{
        keyId.add(0);
      }
    }
    print("keyId: $keyId");
  }
}
