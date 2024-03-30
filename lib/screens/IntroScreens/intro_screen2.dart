import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[100],
      child: LottieBuilder.network(
        "https://lottie.host/3efea095-da2d-4c6a-82eb-9e0e4f740fd7/0m8kg3QM9p.json",
        height: 300,
        alignment: Alignment(0, -0.5),
      ),
    );
  }
}
