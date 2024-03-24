import 'package:flutter/material.dart';
import 'package:qr_scanner/homePage.dart';
import 'package:qr_scanner/profile.dart';
import 'package:qr_scanner/scanner.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index=0;
  final screens=[
    const homePage(),
    const QRViewExample(),
    const ProfilePage()
  ];
   

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: screens[index],
       bottomNavigationBar: NavigationBar( 
        backgroundColor: Colors.white,
        animationDuration: Duration(seconds: 3),
          indicatorColor: Colors.teal,
          onDestinationSelected: (int index) {
            setState(() {
              this.index = index;
            });
          },
          selectedIndex: index,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.qr_code),
              label: 'Scan',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],

        ),
        

    );
  }
}