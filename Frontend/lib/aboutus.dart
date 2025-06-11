import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with Gradient
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'About Us',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF12372A),
                      Color(0xFF2E7D32),
                      Color(0xFF4CAF50),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Hero Section
                    _buildHeroSection(),

                    // Content Sections
                    _buildContentSection(),

                    // Team Section
                    _buildTeamSection(),

                    // Footer
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // App Icon/Logo
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 5,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('images/logoback.png'),
              ),
            ),
            const SizedBox(height: 20),

            // Welcome Text
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'NutriGuide',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Where your health is our priority',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.people_outline,
            title: 'Who We Are',
            content:
                'At NutriGuide, we are a dedicated team of healthcare professionals, developers, and wellness advocates committed to improving health outcomes. With years of experience in the healthcare industry, we understand the challenges individuals face in managing their health.',
            gradient: const LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            ),
          ),
          const SizedBox(height: 20),

          _buildInfoCard(
            icon: Icons.visibility_outlined,
            title: 'Our Vision',
            content:
                'We envision a world where everyone has access to the tools and knowledge needed to lead a healthier life. By leveraging cutting-edge technology, we aim to simplify healthcare access and provide users with the resources they need to make informed decisions.',
            gradient: const LinearGradient(
              colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
            ),
          ),
          const SizedBox(height: 20),

          _buildFeaturesCard(),
          const SizedBox(height: 20),

          _buildInfoCard(
            icon: Icons.security_outlined,
            title: 'Our Commitment',
            content:
                'We are committed to protecting your privacy and ensuring that your health information is secure. Our user-friendly interface makes it easy to navigate, while our dedicated support team is always here to assist you.',
            gradient: const LinearGradient(
              colors: [Color(0xFFE8F5E8), Color(0xFFC8E6C9)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required LinearGradient gradient,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 28, color: const Color(0xFF12372A)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF12372A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2E2E2E),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final features = [
      {
        'icon': Icons.track_changes,
        'title': 'Personalized Health Tracking',
        'desc': 'Monitor your health metrics and set achievable goals',
      },
      {
        'icon': Icons.school,
        'title': 'Expert Guidance',
        'desc': 'Access resources created by healthcare professionals',
      },

      {
        'icon': Icons.security,
        'title': 'Secure Communication',
        'desc': 'Safe platform to consult with healthcare providers',
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.featured_play_list,
                    size: 28,
                    color: Color(0xFF12372A),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'What We Do',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF12372A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...features
                .map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF12372A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature['title'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF12372A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feature['desc'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2E2E2E),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12372A), Color(0xFF2E7D32)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              '🌟 Meet Our Team 🌟',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),

            const SizedBox(height: 30),

            // First Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamMember('Engy', 'images/Cake.jpg'),
                _buildTeamMember('Arwa', 'images/watermalon.png'),
                _buildTeamMember('Salma', 'images/pinapple.png'),
                _buildTeamMember('Youstena', 'images/pizza.png'),
              ],
            ),
            const SizedBox(height: 30),

            // Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamMember('Momo', 'images/frise.png'),
                _buildTeamMember('Abdelbaset', 'images/Orange.png'),
                _buildTeamMember('Emad', 'images/mango.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String imagePath) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF12372A),
            ),
          ),
        ),
      ],
    );
  }
}
