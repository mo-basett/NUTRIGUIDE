import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:projeect/analys.dart';
import 'package:projeect/analys2.dart';
import 'package:projeect/camerapage.dart';
import 'package:projeect/historypage.dart';
import 'package:projeect/profilepage.dart';
import 'package:projeect/scanresult2.dart';
import 'package:projeect/settingpage.dart';
import 'package:projeect/scanresultpage.dart';
import 'package:projeect/chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  File? _capturedImage;
  int _currentIndex = 2;

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _pulseController;
  late AnimationController _navController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _navController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Slide animation for buttons
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Pulse animation
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _animationController.forward();
    _navController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _buttonAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    _pulseController.dispose();
    _navController.dispose();
    super.dispose();
  }

  Future<void> _captureImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _capturedImage = File(image.path);
      });
      _navigateToScanResultPage(_capturedImage!);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _capturedImage = File(image.path);
      });
      _navigateToScanResultPage(_capturedImage!);
    }
  }

  void _navigateToScanResultPage(File imageFile) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Scanresult2(imageFile: imageFile),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Analys2()),
        );
        break;
      case 2:
        // Current page (Home)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'Home',
            style: TextStyle(
              color: Color(0xFF12372A),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Enhanced hero section with gradient overlay
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 400,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/home.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Subtle gradient overlay for text readability
                        Container(
                          width: double.infinity,
                          height: 400,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 180,
                          left: 20,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Let's start a healthy",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "journey",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Enhanced buttons section with modern cards
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Camera button with enhanced design
                      AnimatedBuilder(
                        animation: _buttonAnimationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              50 * (1 - _buttonAnimationController.value),
                            ),
                            child: Opacity(
                              opacity: _buttonAnimationController.value,
                              child: ScaleTransition(
                                scale: _pulseAnimation,
                                child: Container(
                                  width: double.infinity,
                                  height: 65,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.orange,
                                        Color(0xFFFF8C00),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const CameraPage(),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Icon(
                                                Icons.camera_alt,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 40),
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Camera",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Take a photo instantly",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      // Upload button with same animation as camera button
                      AnimatedBuilder(
                        animation: _buttonAnimationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              50 * (1 - _buttonAnimationController.value),
                            ),
                            child: Opacity(
                              opacity: _buttonAnimationController.value,
                              child: ScaleTransition(
                                scale: _pulseAnimation,
                                child: Container(
                                  width: double.infinity,
                                  height: 65,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFB9935),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFB9935,
                                        ).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: _pickImageFromGallery,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Icon(
                                                Icons.upload_file_rounded,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 40),
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Upload",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Choose from gallery",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 100), // Extra space for bottom nav
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavBar(),
    );
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
            isCenter: true,
          ),
          _buildModernNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            index: 3,
            label: 'Settings',
            color: const Color(0xFF86A789),
          ),
          _buildModernNavItem(
            icon: (FontAwesomeIcons.robot), // or FontAwesomeIcons.home
            activeIcon: (FontAwesomeIcons.robot), // solid version
            index: 4,
            label: 'chatbot',
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
}
