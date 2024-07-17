import 'package:flutter/material.dart';
import 'package:spliteasy/LoginSignupScreens/LogIn.dart';
import 'package:spliteasy/LoginSignupScreens/SignUp.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "assets/images/logo.png",
            width: 200,
            height: 200,
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: const Color(0xffdff169),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Remove rounded corners
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp()));
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1f2128)),
                  ))),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: const Color(0xff1f2128),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Remove rounded corners
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LogIn()));
                  },
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: const TextSpan(
                text: 'By registering, you accept SplitEasy ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'Sofia Pro'),
                children: [
                  TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                  TextSpan(text: ' and '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                ]),
          )
        ]),
      )),
    );
  }
}
