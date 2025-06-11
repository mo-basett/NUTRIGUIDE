import 'package:flutter/material.dart';
import 'package:projeect/historypage.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/profilepage.dart';
import 'package:projeect/settingpage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Analys extends StatefulWidget {
  const Analys({super.key});

  @override
  State<Analys> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Analys> {
  int _currentIndex = 1; // This represents the "Analys" page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analysis',
          style: TextStyle(
            color: Color(0xFF12372A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Vegetablesset05.jpg'),
            fit: BoxFit.fill,
            opacity: 0.1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "-Your analysis for today:",
              style: TextStyle(
                fontFamily: "Schyler",
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 25),
            const Align(
              widthFactor: double.infinity,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "Protein",
                  style: TextStyle(
                    fontFamily: "Schyler",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            LinearPercentIndicator(
              lineHeight: 40,
              percent: 0.7,
              progressColor: const Color(0xffE1D93E),
              backgroundColor: Colors.grey.shade200,
              barRadius: const Radius.circular(30),
              animation: true,
              animationDuration: 1000,
              center: const Text(
                "70%",
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              widthFactor: double.infinity,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "Fats",
                  style: TextStyle(
                    fontFamily: "Schyler",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            LinearPercentIndicator(
              lineHeight: 40,
              percent: 0.4,
              progressColor: const Color(0xff527660),
              backgroundColor: Colors.grey.shade200,
              barRadius: const Radius.circular(30),
              animation: true,
              animationDuration: 1000,
              center: const Text(
                "40%",
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              widthFactor: double.infinity,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "Vitamins",
                  style: TextStyle(
                    fontFamily: "Schyler",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            LinearPercentIndicator(
              lineHeight: 40,
              percent: 1,
              progressColor: const Color(0xffBEA381),
              backgroundColor: Colors.grey.shade200,
              barRadius: const Radius.circular(30),
              animation: true,
              animationDuration: 1000,
              center: const Text(
                "100%",
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              widthFactor: double.infinity,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "Calories",
                  style: TextStyle(
                    fontFamily: "Schyler",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            LinearPercentIndicator(
              lineHeight: 40,
              percent: 0.8,
              progressColor: const Color(0xff472E1A),
              backgroundColor: Colors.grey.shade200,
              barRadius: const Radius.circular(30),
              animation: true,
              animationDuration: 1000,
              center: const Text(
                "80%",
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.access_time_filled_outlined,
                size: 30,
                color: Color(0xff12372A),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 60,
                  color:
                      _currentIndex == 1
                          ? const Color(0xFF86A789)
                          : Colors.transparent,
                ),
                const Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFF86A789),
                  size: 30,
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
