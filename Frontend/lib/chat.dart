import 'package:flutter/material.dart';
import 'package:projeect/analys.dart';
import 'package:projeect/historypage.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/settingpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:projeect/loginscreen2.dart' as Lgscreen;

var user_id = Lgscreen.id_user; // Replace with actual user ID logic

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"sender": "bot", "text": "Hello! How can I assist you today?"},
  ];

  int _currentIndex = 4;
  final ScrollController _scrollController = ScrollController();
  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;

    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
      _controller.clear();
    });

    try {
      final response = await http.post(
        Uri.parse('https://mmm12212.pythonanywhere.com/ask_chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "message": userMessage,
          "user_id": user_id, // Pass user_id in the request body
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botReply = data['answer'] ?? "Sorry, I couldn't understand.";

        setState(() {
          _messages.add({"sender": "bot", "text": botReply});
        });
      } else {
        setState(() {
          _messages.add({
            "sender": "bot",
            "text": "Error: Unable to get response from server.",
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender": "bot", "text": "Error: ${e.toString()}"});
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);

        // Send the file to the API
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('http://momo66.pythonanywhere.com/upload/'),
        );
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          print("File uploaded successfully");
        } else {
          print("Failed to upload file: ${response.statusCode}");
        }
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(360, 70),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(17.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              tooltip: 'Back to Home',
              hoverColor: Colors.transparent,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ),
          backgroundColor: Color(0xFF6D8F5D),
          automaticallyImplyLeading: false,
          title: Container(
            height: 85,
            padding: EdgeInsets.only(top: 15, left: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.smart_toy, color: Color(0xFF6D8F5D)),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    "Nutri",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Vegetablesset05.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.2,
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  bool isUser = message["sender"] == "user";

                  return Row(
                    mainAxisAlignment:
                        isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.smart_toy,
                            color: Color(0xFF6D8F5D),
                          ),
                        ),
                      if (!isUser) SizedBox(width: 8),
                      Column(
                        crossAxisAlignment:
                            isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          if (isUser)
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF6D8F5D),
                              ),
                            ),
                          if (isUser) SizedBox(height: 4),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isUser ? Color(0xFF6D8F5D) : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft:
                                    isUser ? Radius.circular(12) : Radius.zero,
                                bottomRight:
                                    isUser ? Radius.zero : Radius.circular(12),
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(
                              message["text"]!,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Color(0xFF6D8F5D),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 28),
                  onPressed: _pickFile,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 120),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        reverse: true,
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: Colors.white),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
