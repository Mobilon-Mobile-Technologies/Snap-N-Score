import 'package:flutter/material.dart';
import 'package:qr_scanner/authentication/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final supabase=Supabase.instance.client;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage'),
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                width: size.width,
                child:  Column(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 60,
                      foregroundImage: NetworkImage(
                          'https://static.vecteezy.com/system/resources/previews/014/194/232/original/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg'),
                    ),
                    const SizedBox(height: 10),
                     Text("${supabase.auth.currentUser?.userMetadata?['name']}",                  
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("${supabase.auth.currentUser?.email}",)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 17.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Share Precise Location",
                  style: TextStyle(
                    fontSize: 20.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Align(
              heightFactor: 3.5,
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 155,
                child: ElevatedButton(
                  onPressed: () async {
                    await supabase.auth.signOut().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    });
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 91, 91)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
