// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:qr_scanner/authentication/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage2 extends StatefulWidget {
  const SignupPage2(
      this.name, this.enrollno, this.email, this.password, this.year,
      {super.key});

  final String name, enrollno, email, password, year;

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final Set<String> _checkedCourses = <String>{};
  final Set<int> _MappedCoursesId = <int>{};
  final supabase = Supabase.instance.client;
  List courses = [];
  int? _selectedSemester;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSemesterDialog().then((_) {
        getdata().then((_) {
          setState(() {});
        });
      });
    });
  }

  //to check dynamic adding of courses in the list
  void debug() {
    debugPrint("$_checkedCourses");
  }

  @override
  Widget build(BuildContext context) {
    debug();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup Page"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: LinearProgressIndicator(
            color: Colors.green,
            value: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text("One Last Thing!!",
                          style: TextStyle(fontSize: 30)),
                      Padding(padding: EdgeInsets.only(bottom: height * 0.1)),
                      const Text("Select your courses",
                          style: TextStyle(fontSize: 20)),
                      Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                      SizedBox(
                        height: height * 0.5,
                        width: height * 0.5,
                        child: ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(courses[index]),
                              value: _checkedCourses.contains(courses[index]),
                              onChanged: (bool? value) {
                                if (value != null && value) {
                                  _checkedCourses.add(courses[index]);
                                } else {
                                  _checkedCourses.remove(courses[index]);
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final sm = ScaffoldMessenger.of(context);
                    // adding user details to the users table
                    await supabase.from('users').insert({
                      'username': widget.name,
                      'enrollment_id': widget.enrollno
                    });

                    // Get the user ID for course enrollment (after user creation)
                    final userResponse = await supabase
                        .from('users')
                        .select('user_id')
                        .eq('enrollment_id', widget.enrollno);
                    final userId = userResponse[0]['user_id'];
                    debugPrint(userId);

                    // Get the course ID for course enrollment (after user creation)
                    for (String cName in _checkedCourses) {
                      debugPrint("Course name: $cName");
                      final course2 = await supabase
                          .from('courses2')
                          .select('course_id')
                          .eq('course_name',cName);
                          final courseId=course2[0]['course_id'];
                          _MappedCoursesId.add(courseId);

                    }
                    debugPrint("Mapped coursesId: $_MappedCoursesId");
                    

                    for (int course in _MappedCoursesId) {
                      await supabase
                          .from('user_courses')
                          .insert({'user_id': userId, 'course_id': course});
                    }

                    await supabase.auth.signUp(
                        password: widget.password,
                        email: widget.email,
                        data: {
                          'name': widget.name,
                          'enroll_no': widget.enrollno,
                          "year": widget.year,
                          "user_id": userId
                        }).then((value) {
                      sm.showSnackBar(SnackBar(
                          content: Text("Signed up ${value.user!.email!}")));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                    }).onError((error, stackTrace) {
                      sm.showSnackBar(
                          SnackBar(content: Text("Signed up $error")));
                    });
                  },
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll<Size>(
                          Size(height * 0.5, height * 0.068)),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.orangeAccent)),
                  child: const Text("Signup"),
                ),
              ],
            ),
          ),
          if (courses.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _showSemesterDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            title: const Text('Enter Semester'),
            content: DropdownButton<int>(
              hint: const Text("Select a semester"),
              items: List<int>.generate(2, (i) => i + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedSemester = newValue;
                });
              },
              value: _selectedSemester,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future getdata() async {
    final data = await supabase
        .from('courses')
        .select()
        .eq('year', widget.year)
        .eq('semester', _selectedSemester.toString());

    for (Map<String, dynamic> map in data) {
      map.forEach((key, value) {
        debugPrint(key);
        if (key != "semester" && key != "year" && value != null) {
          courses.add(value);
        }
      });
    }
  }
}
