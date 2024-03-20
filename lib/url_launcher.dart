import 'package:flutter/material.dart';

class Url_Launcher extends StatefulWidget {
  const Url_Launcher({super.key});

  @override
  State<Url_Launcher> createState() => _Url_LauncherState();
}

class _Url_LauncherState extends State<Url_Launcher> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet( 
      onClosing: (){},
      builder: (BuildContext context){
        return Container(
          height: 200,
          color: Colors.teal,
          child: Column(
            children: [
              const Text('This is a Bottom Sheet'),
              ElevatedButton(
                onPressed: (){},
                child: const Text('Close'),
              )
            ],
          ),
        );
      }
    );
  }
}

