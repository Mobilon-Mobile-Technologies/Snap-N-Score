import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Colors.purple, Colors.blue],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Container(
      color: const Color.fromARGB(255, 32, 25, 41),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => linearGradient,
            child: Text(
              "Welcome to \nSnap n' Score",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
            ),
          ),
          Center(
            child: LottieBuilder.network(
              "https://lottie.host/eb34e134-4795-4366-b438-ef853f5d2d50/lynIeIHiUd.json",
              repeat: true,
              frameRate: FrameRate(30),
            ),
          ),
        ],
      ),
    );
  }
}
