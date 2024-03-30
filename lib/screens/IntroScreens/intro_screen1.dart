import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[100],
      child: Center(
        child: LottieBuilder.network(
            "https://lottie.host/42bae0f0-5075-4cf1-8fd8-eb8beedf99ac/oBUCrI4MUo.json",
            repeat: true,),
      ),
    );
  }
}
