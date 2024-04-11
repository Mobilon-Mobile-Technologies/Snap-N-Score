import 'package:flutter/material.dart';
import 'package:qr_scanner/authentication/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage2 extends StatefulWidget {
  const SignupPage2(this.name,this.enrollno, this.email, this.password, this.year,
      {super.key});

  final String name, enrollno, email, password, year;

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final Set<String> _checkedCourses = <String>{};
  final supabase = Supabase.instance.client;
  List courses = [];

  @override
  void initState() {
    super.initState();
    getdata().then((_) {
      setState(() {});
    });
  }

  //to check dynamic adding of courses in the list
  void debug() {
    print(_checkedCourses);
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
            padding: EdgeInsets.all(15),
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
                      Container(
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
                OutlinedButton.icon(
                  icon: const Icon(Icons.navigate_next_rounded),
                  label: const Text("next"),
                  onPressed: () async {
                    final sm = ScaffoldMessenger.of(context);
                    await supabase.auth.signUp(
                        password: widget.password,
                        email: widget.email,
                        data: {
                          'name': widget.name,
                          'enroll_no':widget.enrollno,
                          "year": widget.year
                        }).then((value) {
                      sm.showSnackBar(SnackBar(
                          content: Text("Signed up ${value.user!.email!}")));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                    }).onError((error, stackTrace) {
                       sm.showSnackBar(SnackBar(
                          content: Text("Signed up ${error}")));
                    });
                  },
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll<Size>(
                          Size(height * 0.5, height * 0.068)),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.orangeAccent)),
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
