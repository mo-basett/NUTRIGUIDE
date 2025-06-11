import 'package:flutter/material.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/registerpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var get_from_login;
var id_user;

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  late Future<List<dynamic>> futureData;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    print('Fetching data...');
    final response = await http.get(
      Uri.parse('http://momo66.pythonanywhere.com//registers/'),
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

  // void save_id_user(var id) {
  //   final response = http.post(
  //     Uri.parse('http://192.168.1.29:8000/save_id'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'id': id_user}),
  //   );
  //   print('User ID saved: $id_user');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff4B6043),
            weight: 100,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
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
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('images/logoback.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              "Log in",
              style: TextStyle(
                fontFamily: "Schyler",
                fontSize: 50,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Color(0xff12372A),
              ),
            ),
            const SizedBox(height: 10),
            // Email TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "name",
                  fillColor: const Color.fromARGB(64, 117, 151, 94),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Password TextField
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
            // Forget password
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontFamily: "Schyler",
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
            // Sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: SizedBox(
                width: double.infinity,
                height: 59,
                child: ElevatedButton(
                  onPressed: () async {
                    List<dynamic> users = await futureData;
                    bool loginSuccessful = false;

                    for (var user in users) {
                      if (nameController.text == user['name'] &&
                          passwordController.text == user['password']) {
                        id_user = user['id'];
                        // save_id_user(id_user);
                        loginSuccessful = true;
                        break;
                      }
                    }

                    if (loginSuccessful) {
                      get_from_login = nameController.text;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('login successful')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('login failed')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB9935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
