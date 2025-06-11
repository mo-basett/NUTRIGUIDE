import 'package:flutter/material.dart';
import 'package:projeect/registerpage.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterPage()),
      );
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('images/1.png', fit: BoxFit.cover),
          // Logo
          Center(
            child: Image.asset('images/logo.png', width: 457, height: 466),
          ),
        ],
      ),
    );
  }
}
