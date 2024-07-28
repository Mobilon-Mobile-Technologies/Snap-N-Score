
import 'package:flutter/material.dart';
import 'package:qr_scanner/authentication/login.dart';
import 'package:qr_scanner/screens/IntroScreens/intro_screen1.dart';
import 'package:qr_scanner/screens/IntroScreens/intro_screen2.dart';
import 'package:qr_scanner/screens/IntroScreens/intro_screen3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool onlastPage = false;
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                onlastPage = (value == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (onlastPage)
                  FilledButton.tonal(
                    style: const ButtonStyle(),
                    onPressed: () async{
                      final pref=await SharedPreferences.getInstance();
                      await pref.setBool('onboarding', true);
                      if(context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                    },
                    child: const Text(
                      "Get started",
                    ),
                  )
                else
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _controller.animateToPage(2,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                        child:  Text("skip",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),),
                      ),
                      SizedBox(width: width*0.15,),
                      SmoothPageIndicator(
                        effect: const ExpandingDotsEffect(
                            expansionFactor: 3, dotColor: Colors.white10),
                        controller: _controller,
                        count: 3,
                      ),
                      SizedBox(width: width*0.15,),
                      GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child:  Text("next",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),),
                      ),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
