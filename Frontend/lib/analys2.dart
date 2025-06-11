import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeect/chat.dart';
import 'package:projeect/historypage.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/profilepage.dart';
import 'package:projeect/settingpage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:projeect/loginscreen2.dart' as Lgscreen;

// Use the correct user_id variable from loginscreen2.dart
// If your login screen exports 'user_id', use that. Otherwise, fix as needed.
var user_id = Lgscreen.id_user; // Replace with actual user ID logic

class Analys2 extends StatefulWidget {
  const Analys2({super.key});

  @override
  State<Analys2> createState() => _MyWidgetState();
}

class NutritionData {
  final double protein;
  final double fats;
  final double vitamins;
  final double calories;

  NutritionData({
    required this.protein,
    required this.fats,
    required this.vitamins,
    required this.calories,
  });
}

class _MyWidgetState extends State<Analys2> {
  final int _currentIndex = 1;
  DateTime? selectedDate;
  late Future<NutritionData> futureNutritionData;
  String selectedPeriod = 'day';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    // Always initialize futureNutritionData to avoid runtime errors
    futureNutritionData = Future.value(
      NutritionData(protein: 0, fats: 0, vitamins: 0, calories: 0),
    );
    // Print user_id for debugging
    print('user_id in Analys2: $user_id');
    // Only fetch data if user_id is valid
    if (user_id != null && user_id.toString().isNotEmpty && user_id != "null") {
      futureNutritionData = fetchAndCalculateNutrition('day', selectedDate);
    }
  }

  void _onPeriodChanged(String period) {
    if (selectedPeriod != period) {
      setState(() {
        selectedPeriod = period;
        // Fetch data for the selected period
        futureNutritionData = fetchAndCalculateNutrition(
          selectedPeriod,
          selectedDate,
        );
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Refetch for the current period with new date
        futureNutritionData = fetchAndCalculateNutrition(
          selectedPeriod,
          selectedDate,
        );
      });
    }
  }

  // Add a cache to store fetched data for each period/date combination
  final Map<String, List<dynamic>> _fetchCache = {};

  Future<List<dynamic>> fetchData(String period, DateTime? date) async {
    String formattedDate =
        date != null
            ? "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
            : "";
    String cacheKey = "$period|$formattedDate";
    // Return cached data if available
    if (_fetchCache.containsKey(cacheKey)) {
      print('Returning cached data for $cacheKey');
      return _fetchCache[cacheKey]!;
    }

    print('Fetching data for $period...');
    String url;
    if (period == 'day') {
      url =
          'http://momo66.pythonanywhere.com/fooddate/$formattedDate/?user_id=$user_id';
    } else if (period == 'week') {
      url =
          'http://momo66.pythonanywhere.com/fooddate/$formattedDate/?user_id=$user_id&range=week';
    } else {
      url =
          'http://momo66.pythonanywhere.com/fooddate/$formattedDate/?user_id=$user_id&range=month';
    }
    final response = await http.get(Uri.parse(url));
    print('Request URL: $url');
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response received: ${response.body}');
      List jsonResponse = json.decode(response.body);
      print('Decoded JSON: $jsonResponse');
      // Cache the result
      _fetchCache[cacheKey] = jsonResponse;
      return jsonResponse;
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  // Extract nutritional values from the nutrition info text
  double extractNutrientValue(String nutInfo, String nutrient) {
    final RegExp regExp = RegExp(r'\*\*' + nutrient + r'\*\*:\s*(\d+\.?\d*)');
    final match = regExp.firstMatch(nutInfo);
    if (match != null) {
      return double.tryParse(match.group(1) ?? '0') ?? 0.0;
    }
    return 0.0;
  }

  // Extract vitamin C percentage from nutrition info
  double extractVitaminC(String nutInfo) {
    final RegExp regExp = RegExp(r'\*\*Vitamin C\*\*:\s*([\d.]+)mg');
    final match = regExp.firstMatch(nutInfo);
    if (match != null) {
      return double.tryParse(match.group(1) ?? '0') ?? 0.0;
    }
    return 0.0;
  }

  Future<NutritionData> fetchAndCalculateNutrition(
    String period,
    DateTime? date,
  ) async {
    try {
      List<dynamic> foods = await fetchData(period, date);

      double totalProtein = 0;
      double totalFats = 0;
      double totalCalories = 0;
      double totalVitaminC = 0;

      for (var food in foods) {
        String nutInfo = food['nut_info'] ?? '';

        // Extract nutritional values
        totalProtein += extractNutrientValue(nutInfo, 'Protein');
        totalFats += extractNutrientValue(nutInfo, 'Fat');
        totalCalories += extractNutrientValue(nutInfo, 'Calories');
        totalVitaminC += extractVitaminC(nutInfo);
      }
      print('Total Protein: $totalProtein');
      print('Total Fats: $totalFats');
      print('Total Calories: $totalCalories');
      print('Total Vitamin C: $totalVitaminC');
      // Set daily goals based on period
      double proteinGoal = 120.0;
      double fatGoal = 65.0;
      double calorieGoal = 2000.0;
      double vitaminCGoal = 100.0;
      if (period == 'week') {
        proteinGoal *= 7;
        fatGoal *= 7;
        calorieGoal *= 7;
        vitaminCGoal *= 7;
      } else if (period == 'month') {
        proteinGoal *= 30;
        fatGoal *= 30;
        calorieGoal *= 30;
        vitaminCGoal *= 30;
      }
      // Convert to percentages (capped at 1.0 for the progress indicator)
      double proteinPercent = (totalProtein / proteinGoal).clamp(0.0, 1.0);
      double fatsPercent = (totalFats / fatGoal).clamp(0.0, 1.0);
      double caloriesPercent = (totalCalories / calorieGoal).clamp(0.0, 1.0);
      double vitaminsPercent = (totalVitaminC / vitaminCGoal).clamp(0.0, 1.0);

      return NutritionData(
        protein: proteinPercent,
        fats: fatsPercent,
        vitamins: vitaminsPercent,
        calories: caloriesPercent,
      );
    } catch (e) {
      print('Error calculating nutrition: $e');
      // Return default values if there's an error
      return NutritionData(
        protein: 0.5,
        fats: 0.3,
        vitamins: 0.8,
        calories: 0.6,
      );
    }
  }

  Widget buildNutrientIndicator(String label, double percent, Color color) {
    return Column(
      children: [
        Align(
          widthFactor: double.infinity,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: "Schyler",
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        LinearPercentIndicator(
          lineHeight: 40,
          percent: percent,
          progressColor: color,
          backgroundColor: Colors.grey.shade200,
          barRadius: const Radius.circular(30),
          animation: true,
          animationDuration: 1000,
          center: Text(
            "${(percent * 100).toInt()}%",
            style: const TextStyle(
              fontFamily: "Schyler",
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryPage()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Chat()),
        );
        break;
    }
  }

  Widget _buildModernBottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildModernNavItem(
            icon: Icons.history,
            activeIcon: Icons.history,
            index: 0,
            label: 'Chat',
            color: const Color(0xFF86A789),
          ),
          _buildModernNavItem(
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics,
            index: 1,
            label: 'Analytics',
            color: const Color(0xFF86A789),
          ),
          _buildModernNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            index: 2,
            label: 'Home',
            color: const Color(0xFF86A789),
          ),
          _buildModernNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            index: 3,
            label: 'Settings',
            color: const Color(0xFF86A789),
            isCenter: true,
          ),
          _buildModernNavItem(
            icon: FontAwesomeIcons.robot,
            activeIcon: FontAwesomeIcons.robot,
            index: 4,
            label: 'Chatbot',
            color: const Color(0xFF12372A),
          ),
        ],
      ),
    );
  }

  Widget _buildModernNavItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required String label,
    required Color color,
    bool isCenter = false,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 12 : 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: isCenter ? 24 : 20,
              color: isActive ? color : Colors.grey.shade600,
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 2),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionContainer(
    Future<NutritionData> futureNutrition,
    String period,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$period Analysis',
            style: const TextStyle(
              fontFamily: "Schyler",
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<NutritionData>(
            future: futureNutrition,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF12372A)),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading nutrition data',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            futureNutrition = fetchAndCalculateNutrition(
                              period,
                              selectedDate,
                            );
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                final nutritionData = snapshot.data!;
                return Column(
                  children: [
                    buildNutrientIndicator(
                      "Protein",
                      nutritionData.protein,
                      const Color(0xffE1D93E),
                    ),
                    buildNutrientIndicator(
                      "Fats",
                      nutritionData.fats,
                      const Color(0xff527760),
                    ),
                    buildNutrientIndicator(
                      "Vitamins",
                      nutritionData.vitamins,
                      const Color(0xffBEA381),
                    ),
                    buildNutrientIndicator(
                      "Calories",
                      nutritionData.calories,
                      const Color(0xff472E1A),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Prevent build if user_id is not set

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.transparent),
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
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Color(0xFF12372A)),
            onPressed: () => _pickDate(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              selectedDate != null
                  ? 'Selected date: ' +
                      '${selectedDate!.year.toString().padLeft(4, '0')}-'
                          '${selectedDate!.month.toString().padLeft(2, '0')}-'
                          '${selectedDate!.day.toString().padLeft(2, '0')}'
                  : 'No date selected',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                  label: const Text('Day'),
                  selected: selectedPeriod == 'day',
                  onSelected: (val) {
                    _onPeriodChanged('day');
                  },
                ),
                const SizedBox(width: 10),
                FilterChip(
                  label: const Text('Week'),
                  selected: selectedPeriod == 'week',
                  onSelected: (val) {
                    _onPeriodChanged('week');
                  },
                ),
                const SizedBox(width: 10),
                FilterChip(
                  label: const Text('Month'),
                  selected: selectedPeriod == 'month',
                  onSelected: (val) {
                    _onPeriodChanged('month');
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildNutritionContainer(
              futureNutritionData,
              StringExtension(selectedPeriod).capitalize(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavBar(),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
