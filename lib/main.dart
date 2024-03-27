import 'package:flutter/material.dart';
import 'package:qr_scanner/authentication/login.dart';
import 'package:qr_scanner/bottomNav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dpbchvnpfkjvkjagaqnh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwYmNodm5wZmtqdmtqYWdhcW5oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEzOTk0OTYsImV4cCI6MjAyNjk3NTQ5Nn0.NSvPVIKngCAEP-YM19KHFwtqsni1YFa-QcAZhCdLrbM',
  );
  runApp(const MyApp());
}

  final supabase=Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _currentScreen=LoginPage();

  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  void _redirectUser() {
    final user = supabase.auth.currentSession;
    if (user != null) {
      setState(() {
        _currentScreen=BottomNavBar();
      });
    } 
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: _currentScreen
    );
  }
}