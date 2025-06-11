import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeect/analys.dart';
import 'package:projeect/historypage.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/registerpage.dart';
import 'package:projeect/settingpage.dart';
import 'package:projeect/loginscreen2.dart' as lgscreen;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

var id_respons;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;
  Uint8List? _image;
  final ImagePicker _picker = ImagePicker();
  final int _currentIndex = 4;

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _avatarAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _avatarScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    fetchUserData();
  }

  void _initializeAnimations() {
    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Button animation controller
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Avatar animation controller
    _avatarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Avatar scale animation
    _avatarScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _avatarAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animations
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _avatarAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _buttonAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    _avatarAnimationController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://momo66.pythonanywhere.com/registers/'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final user = data.firstWhere(
          (user) => user['id'] == lgscreen.id_user,
          orElse: () => null,
        );

        if (user != null) {
          setState(() {
            nameController.text = user['name'];
            emailController.text = user['email'];
            passwordController.text = user['password'];
            phoneController.text = user['phone'];
            ageController.text = user['age'].toString();
            selectedGender = user['gender'];
            id_respons = user['id'];
          });
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load user data')));
    }
  }

  Future<void> changeProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageData = await pickedFile.readAsBytes();
      setState(() {
        _image = imageData;
      });
      // Animate the avatar when image changes
      _avatarAnimationController.reset();
      _avatarAnimationController.forward();
    }
  }

  void saveProfile() async {
    try {
      // Prepare the updated user data
      final updatedUserData = {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'phone': phoneController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'gender': selectedGender,
      };

      // Send the updated data to the server
      final response = await http.put(
        Uri.parse(
          'http://momo66.pythonanywhere.com/registers/$id_respons/update/',
        ), // Replace with your actual API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUserData),
      );

      if (response.statusCode == 200) {
        // Successfully updated the profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        // Failed to update the profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      // Handle any errors
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating profile'),
        ),
      );
    }
  }

  void cancelChanges() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    ageController.clear();
    setState(() {
      selectedGender = null;
      _image = null;
    });
  }

  void logOut() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logged out successfully!')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const lgscreen.LoginScreen2()),
    );
  }

  Widget _buildAnimatedTextField(
    TextEditingController controller,
    String label,
    int index, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double delayedValue = (_animationController.value - (index * 0.1))
            .clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 30 * (1 - delayedValue)),
          child: Opacity(
            opacity: delayedValue,
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Color(0xFF5D7752)),
                border: const OutlineInputBorder(),
                fillColor: const Color(0xff3d75975e),
                filled: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton(
    String text,
    VoidCallback onPressed,
    int index, {
    Color? backgroundColor,
    Size? minimumSize,
  }) {
    return AnimatedBuilder(
      animation: _buttonAnimationController,
      builder: (context, child) {
        double delayedValue = (_buttonAnimationController.value - (index * 0.1))
            .clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 20 * (1 - delayedValue)),
          child: Opacity(
            opacity: delayedValue,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                backgroundColor: backgroundColor ?? const Color(0xFFFB9935),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 16,
                ),
                minimumSize: minimumSize ?? const Size(162, 47),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xffFFFFFF),
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'Profile',
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Vegetablesset05.jpg'),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScrollConfiguration(
              behavior: NoScrollBehavior(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animated Avatar Section
                    ScaleTransition(
                      scale: _avatarScaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            SizedBox(
                              width: 136.2,
                              height: 139,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      _image != null
                                          ? MemoryImage(_image!)
                                          : const AssetImage(
                                                'images/logoback.png',
                                              )
                                              as ImageProvider,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 1,
                              left: 100,
                              top: 105,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF86A789),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: changeProfilePicture,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Animated Text Fields
                    _buildAnimatedTextField(nameController, 'Name', 0),
                    const SizedBox(height: 30),
                    _buildAnimatedTextField(emailController, 'Email', 1),
                    const SizedBox(height: 30),
                    _buildAnimatedTextField(
                      passwordController,
                      'Password',
                      2,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),

                    // Animated Row for Phone and Age
                    SlideTransition(
                      position: _slideAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildAnimatedTextField(
                              phoneController,
                              'Phone',
                              3,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildAnimatedTextField(
                              ageController,
                              'Age',
                              4,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Animated Gender Dropdown
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        double delayedValue = (_animationController.value - 0.5)
                            .clamp(0.0, 1.0);
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - delayedValue)),
                          child: Opacity(
                            opacity: delayedValue,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 1,
                                right: 200,
                              ),
                              child: SizedBox(
                                width: 153,
                                height: 50,
                                child: DropdownButtonFormField<String>(
                                  value: selectedGender,
                                  hint: const Text('Gender'),
                                  items:
                                      ['Male', 'Female']
                                          .map(
                                            (gender) => DropdownMenuItem(
                                              value: gender,
                                              child: Text(gender),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Color(0xFF5D7752),
                                    ),
                                    border: OutlineInputBorder(),
                                    fillColor: Color(0xff3d75975e),
                                    filled: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    // Animated Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedButton('Save', saveProfile, 0),
                        const SizedBox(width: 26),
                        _buildAnimatedButton('Cancel', cancelChanges, 1),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Animated Logout Button
                    _buildAnimatedButton(
                      'Log Out',
                      logOut,
                      2,
                      backgroundColor: const Color(0xFFFB9935),
                      minimumSize: const Size(201, 47),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
