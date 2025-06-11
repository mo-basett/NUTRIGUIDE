import 'package:flutter/material.dart';
import 'package:projeect/loginscreen2.dart';
import 'package:projeect/signupscreen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF75975E),
      body: ScrollConfiguration(
        behavior: NoScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 600,
                child: Stack(
                  children: [
                    Positioned(
                      left: 64,
                      right: 64,
                      child: SizedBox(
                        width: 262,
                        height: 344,
                        child: Image.asset(
                          'images/Rectangle 35.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 64,
                      right: 64,
                      top: 183,
                      child: SizedBox(
                        width: 300,
                        height: 276,
                        child: Image.asset(
                          'images/Ellipse 17.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 70,
                      right: 72,
                      top: 78,
                      child: SizedBox(
                        width: 248,
                        height: 344,
                        child: Image.asset(
                          'images/salat.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 17,
                      top: 471,
                      child: Column(
                        children: [
                          Container(
                            width: 357,
                            height: 70,
                            alignment: Alignment.center,
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Nutri',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 70.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'GUIDE',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w200,
                                      fontSize: 70.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '"Building a healthier tomorrow"',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 59,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB9935),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen2(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 59,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB9935),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                   onPressed: () {
                    
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
