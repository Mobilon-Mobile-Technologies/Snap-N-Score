import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink[100],
      child: Center(
        child: LottieBuilder.network(
          "https://lottie.host/e507a29b-b2ed-4ff4-a449-4f615bde2242/pLExL8PKaf.json",
          repeat: true,
        ),
      ),
    );
  }
}
