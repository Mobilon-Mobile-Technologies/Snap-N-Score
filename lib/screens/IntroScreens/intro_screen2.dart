import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 23, 36, 35),
      child: LottieBuilder.network(
        "https://lottie.host/42bae0f0-5075-4cf1-8fd8-eb8beedf99ac/oBUCrI4MUo.json",
        height: 300,
        alignment: const Alignment(0, -0.5),
      ),
    );
  }
}
