import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spliteasy/LoginSignup%20Screens/Welcome.dart';
import 'package:spliteasy/OnBoarding%20Screens/onBoarding1.dart';
import 'package:spliteasy/OnBoarding%20Screens/onBoarding2.dart';
import 'package:spliteasy/OnBoarding%20Screens/onBoarding3.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: const [OnBoarding1(), OnBoarding2(), OnBoarding3()],
        ),
        Container(
            alignment: const Alignment(0, 0.90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(3);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xffAEBDC2),
                      ),
                    )),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const WormEffect(
                      spacing: 10,
                      radius: 10,
                      dotWidth: 5.0,
                      dotHeight: 5.0,
                      dotColor: Color(0xffAEBDC2),
                      activeDotColor: Color(0xff1F2128)),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1F2128),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const SizedBox(
                            width: 110,
                            height: 60,
                            child: Center(
                              child: Text(
                                'Done',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ))
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1F2128),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const SizedBox(
                            width: 110,
                            height: 60,
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ))
              ],
            ))
      ],
    ));
  }
}
