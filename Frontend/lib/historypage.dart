import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projeect/analys.dart';
import 'package:projeect/analys2.dart';
import 'package:projeect/chat.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/profilepage.dart';
import 'package:projeect/settingpage.dart';
import 'package:projeect/loginscreen2.dart' as Lgscreen;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> displayItems = [];
  bool _isLoading = true;
  var user_id = Lgscreen.id_user;

  @override
  void initState() {
    super.initState();
    _fetchFoodHistory();
  }

  // Food mapping with images and colors
  final Map<String, Map<String, dynamic>> foodMapping = {
    'pizza': {'image': 'images/pizza.png', 'color': Colors.red},
    'cabbage': {'image': 'images/white.png', 'color': Colors.green},
    'eggplant': {
      'image': 'images/eggplant.png',
      'color': const Color(0xff979797),
    },
    'tomato': {'image': 'images/Tomato.png', 'color': const Color(0xffFF896D)},
    'carrot': {'image': 'images/carrot.png', 'color': const Color(0xffD57A34)},
    'corn': {'image': 'images/corn.png', 'color': const Color(0xffF0C861)},
    'turnip': {'image': 'images/turnip.png', 'color': const Color(0xffE18BBA)},
    'garlic': {'image': 'images/garlic.png', 'color': const Color(0xffDDB69A)},
    'ginger': {'image': 'images/ginger.png', 'color': const Color(0xffA67C52)},
    'cucumber': {
      'image': 'images/cucumber.png',
      'color': const Color(0xff8BC34A),
    },
    'chilli pepper': {
      'image': 'images/chilli pepper.png',
      'color': const Color(0xffFF5722),
    },
    'frise': {'image': 'images/frise.png', 'color': const Color(0xffFF9800)},
    'pear': {'image': 'images/pear.png', 'color': const Color(0xffC5E1A5)},
    'peas': {'image': 'images/peas.png', 'color': const Color(0xff66BB6A)},
    'hot dog': {
      'image': 'images/hot dog.png',
      'color': const Color(0xffFFB300),
    },
    'baked potato': {
      'image': 'images/baked potato.png',
      'color': const Color(0xffD2B48C),
    },
    'bacon': {'image': 'images/becon.png', 'color': const Color(0xffD30606)},
    'burger': {'image': 'images/burger.png', 'color': const Color(0xff8D6E63)},
    'crispy chicken': {
      'image': 'images/crispy chicken.png',
      'color': const Color(0xffFFB300),
    },
    'cheese': {'image': 'images/cheese.png', 'color': const Color(0xffF4B402)},
    'donuts': {'image': 'images/donats.png', 'color': const Color(0xffF48FB1)},
    'pineapple': {
      'image': 'images/pinapple.png',
      'color': const Color(0xffFFEB3B),
    },
    'pomegranate': {
      'image': 'images/pomegranate.png',
      'color': const Color(0xffC62828),
    },
    'potato': {'image': 'images/potato.png', 'color': const Color(0xffD2B48C)},
    'radish': {'image': 'images/raddish.png', 'color': const Color(0xffF06292)},
    'apple': {'image': 'images/apple.png', 'color': const Color(0xffD30606)},
    'watermelon': {
      'image': 'images/watermalon.png',
      'color': const Color(0xff70AC10),
    },
    'onion': {'image': 'images/onion.png', 'color': const Color(0xffE39E2E)},
    'mango': {'image': 'images/mango.png', 'color': const Color(0xffE3C900)},
    'soybeans': {
      'image': 'images/soybeans.png',
      'color': const Color(0xffFFB870),
    },
    'bell pepper': {
      'image': 'images/bellpapper.png',
      'color': const Color(0xff024A0B),
    },
    'orange': {'image': 'images/orange.png', 'color': const Color(0xffFF8509)},
    'jalapeno': {
      'image': 'images/jalapeno.png',
      'color': const Color(0xff086300),
    },
    'kiwi': {'image': 'images/kiwi.png', 'color': const Color(0xff8E7925)},
    'lemon': {'image': 'images/lemon.png', 'color': Colors.yellow},
    'beetroot': {
      'image': 'images/beetroot.png',
      'color': const Color(0xff8C0048),
    },
    'milk': {'image': 'images/milk.png', 'color': Colors.pink},
    'eggs': {'image': 'images/eggs.png', 'color': const Color(0xffA35E18)},
  };

  Future<void> _fetchFoodHistory() async {
    try {
      if (user_id == null || user_id.toString().isEmpty || user_id == "null") {
        print('Invalid user_id: $user_id');
        setState(() {
          _isLoading = false;
          displayItems = [];
        });
        return;
      }

      // Get current date
      String formattedDate =
          "${DateTime.now().year.toString().padLeft(4, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

      // Fetch data from backend
      String url =
          'http://momo66.pythonanywhere.com/fooddate/$formattedDate/?user_id=$user_id';
      print('Fetching from URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> foodData = json.decode(response.body);
        print('Received food data: $foodData');

        // Create display items from backend data
        List<Map<String, dynamic>> items = [];
        Set<String> addedFoods = {}; // To avoid duplicates

        for (var food in foodData) {
          String foodName = food['namefood']?.toString().toLowerCase() ?? '';

          // Check if this food exists in our mapping and hasn't been added yet
          if (foodMapping.containsKey(foodName) &&
              !addedFoods.contains(foodName)) {
            items.add({
              'name': _capitalizeFirstLetter(foodName),
              'image': foodMapping[foodName]!['image'],
              'color': foodMapping[foodName]!['color'],
            });
            addedFoods.add(foodName);
          }
        }

        setState(() {
          displayItems = items;
          _isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          _isLoading = false;
          displayItems = [];
        });
      }
    } catch (e) {
      print('Error fetching food history: $e');
      setState(() {
        _isLoading = false;
        displayItems = [];
      });
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Analys2()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
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
            label: 'History',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(390, 67),
        child: AppBar(
          leading: Icon(Icons.arrow_back, color: Colors.transparent),
          title: const Text(
            'History',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF12372A),
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 4.0,
          shadowColor: Colors.black.withOpacity(0.4),
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Color(0xFF12372A)),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _fetchFoodHistory();
              },
            ),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF12372A)),
              )
              : displayItems.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.food_bank_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No food history found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 120 / 190,
                  ),
                  itemCount: displayItems.length,
                  itemBuilder: (context, index) {
                    final item = displayItems[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                item['image'],
                                height: 140,
                                width: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.food_bank,
                                    size: 64,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      bottomNavigationBar: _buildModernBottomNavBar(),
    );
  }
}
