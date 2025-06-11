import 'package:flutter/material.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/loginscreen2.dart';



class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF75975E),
      body: Column(
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
                  top: 460,
                  child: Column(
                    children: [
                      Container(
                        width: 370,
                        height: 80,
                        alignment: Alignment.center,
                        child: const Text(
                          'Take Health Into Your Own Hands',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33),
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
                  'Get Started',
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
    );
  }
}
