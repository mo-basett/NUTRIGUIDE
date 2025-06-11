import 'package:flutter/material.dart';

class Introchat extends StatelessWidget {
  const Introchat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF75975E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hello,\nI'm Nutri",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 180,
                width: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    height: 95,
                    width: 111,
                    child: Image.asset(
                      'images/Vector.png', 
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to our Nutrition \nChatbot! \nWe're here to help you on your \njourney to better health. Whether \nyou have questions about meal \nplanning, healthy recipes, or \ndietary tips, just ask! Let's get \nstarted on your path to wellness!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Let's talk",
                  style: TextStyle(
                    fontSize: 41,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B6043),
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
