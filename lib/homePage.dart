import 'package:flutter/material.dart';
import 'package:qr_scanner/bottomNav.dart';
import 'package:qr_scanner/scanner.dart';


class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ninety Percent Club'),
          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: QRViewExample(),

              ),
              Expanded(flex: 1,child: BottomNavBar())
            ],
          ),
        ),
        
       );
  }
}
