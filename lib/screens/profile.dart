// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_scanner/authentication/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;  // Store the selected image
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadProfilePicture(_imageFile!);  // Upload the image
    }
  }

  Future<void> _uploadProfilePicture(File image) async {
    final supabase = Supabase.instance.client;
    try {
      final userId = supabase.auth.currentUser?.id;
      final fileName = '$userId/profile_pic.jpg';

      final storageResponse = await supabase.storage.from('profile-pictures').upload(fileName, image);
      final imageUrl = supabase.storage.from('profile-pictures').getPublicUrl(fileName);

      // Save the image URL to the user's metadata
      await supabase.from('users').update({'profile_pic': imageUrl}).eq('id', userId);
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,  // Pick image on tap
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 60,
                      foregroundImage: _imageFile != null
                          ? FileImage(_imageFile!)  // Display the picked image
                          : NetworkImage(
                              supabase.auth.currentUser?.userMetadata?['profile_pic'] ??
                              'https://static.vecteezy.com/system/resources/previews/014/194/232/original/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg',
                            ) as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${supabase.auth.currentUser?.userMetadata?['name']}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("${supabase.auth.currentUser?.email}"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Align(
            heightFactor: 3.5,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 155,
              child: FilledButton.tonal(
                onPressed: () async {
                  await supabase.auth.signOut().then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red[900]),
                ),
                child: const Text(
                  'Log out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
