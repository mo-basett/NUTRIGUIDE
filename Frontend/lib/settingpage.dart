import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeect/aboutus.dart';
import 'package:projeect/analys.dart';
import 'package:projeect/analys2.dart';
import 'package:projeect/historypage.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/profilepage.dart';
import 'package:projeect/chat.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  final int _currentIndex = 3;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 3:
        // Current page (Settings)
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
        leading: Icon(Icons.arrow_back, color: Colors.transparent),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xff12372A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xff12372A)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Vegetablesset05.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [_buildProfileSection(), _buildSettingsSection()],
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

  Widget _buildProfileSection() {
    return Container(padding: const EdgeInsets.all(20));
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernListTile(
            Icons.account_circle_outlined,
            'Account',
            'Personal information & security',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          _buildDivider(),
          _buildModernListTile(
            Icons.notifications_outlined,
            'Notifications',
            'Push notifications & alerts',
          ),
          _buildDivider(),
          _buildModernListTile(
            Icons.share_outlined,
            'Share App',
            'Tell your friends about us',
          ),
          _buildDivider(),
          _buildModernListTile(
            Icons.star_outline,
            'Rate Us',
            'Share your experience',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RatingPage()),
              );
            },
          ),
          _buildDivider(),
          _buildModernListTile(
            Icons.info_outline,
            'About Us',
            'Learn more about our app',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          _buildDivider(),
          _buildModernListTile(
            Icons.logout_outlined,
            'Log Out',
            'Sign out of your account',
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModernListTile(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color:
                      isDestructive
                          ? Colors.red.withOpacity(0.1)
                          : const Color(0xFF86A789).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : const Color(0xff12372A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isDestructive
                                ? Colors.red
                                : const Color(0xff12372A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 80),
      child: Container(height: 1, color: Colors.grey[200]),
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
}

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> with TickerProviderStateMixin {
  int _rating = 0;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF86A789), Color(0xff12372A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  'Rate Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Color(0xFF86A789),
                          size: 60,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Enjoying our app?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff12372A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Please take a moment to rate us!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                                _bounceController.forward().then((_) {
                                  _bounceController.reverse();
                                });
                              },
                              child: AnimatedBuilder(
                                animation: _bounceAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale:
                                        index < _rating
                                            ? _bounceAnimation.value
                                            : 1.0,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Icon(
                                        index < _rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color:
                                            index < _rating
                                                ? const Color(0xFFFFD700)
                                                : Colors.grey[300],
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _rating > 0
                                    ? () {
                                      Navigator.pop(context);
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF86A789),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Submit Rating',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}
