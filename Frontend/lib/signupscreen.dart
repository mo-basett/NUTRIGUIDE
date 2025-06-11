import 'package:flutter/material.dart';
import 'package:projeect/getstarted.dart';
import 'package:http/http.dart' as http;
import 'package:projeect/getstarted.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? _selectedGender;
  late Future<List<dynamic>> futureData;
  bool loginSuccessful = false;
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    print('Fetching data...');
    final response = await http.get(
      Uri.parse('http://momo66.pythonanywhere.com/registers/'),
    );

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response received: ${response.body}');
      List jsonResponse = json.decode(response.body);
      print('Decoded JSON: $jsonResponse');
      return jsonResponse;
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  Future<void> registerUser() async {
    final String apiUrl = 'http://momo66.pythonanywhere.com/registers/create/';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'phone': phoneController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'gender': _selectedGender,
      }),
    );

    if (response.statusCode == 200) {
      // Registration successful
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Getstarted()),
      );
    } else {
      // Registration failed
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration failed')));
    }
  }

  Future<bool> login() async {
    List<dynamic> users = await futureData;

    for (var user in users) {
      if (nameController.text == user['name']) {
        return true;
      }
      break;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B6043)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/Vegetablesset05.jpg'),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('images/logoback.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sign up",
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0xff12372A),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: const Color.fromARGB(64, 117, 151, 94),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    fillColor: const Color.fromARGB(64, 117, 151, 94),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    fillColor: const Color.fromARGB(64, 117, 151, 94),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          fillColor: const Color.fromARGB(64, 117, 151, 94),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: "Age",
                          fillColor: const Color.fromARGB(64, 117, 151, 94),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Gender selection section moved here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    const Text(
                      'Gender:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Male',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      ageController.text.isEmpty ||
                      _selectedGender == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                      ),
                    );
                    return;
                  } else if (!emailController.text.contains('@') ||
                      !emailController.text.contains('.')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid email address')),
                    );
                    return;
                  } else if (passwordController.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password must be at least 8 characters'),
                      ),
                    );
                    return;
                  } else if (phoneController.text.length != 11) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phone number must be 11 digits'),
                      ),
                    );
                    return;
                  } else if (await login()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('not sussuful')),
                    );
                    return;
                  } else {
                    registerUser();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Getstarted(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB9935),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 90,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(fontSize: 25),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
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
