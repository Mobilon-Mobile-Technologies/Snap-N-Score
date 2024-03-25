import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const BottomNavBar()
    );
  }
}