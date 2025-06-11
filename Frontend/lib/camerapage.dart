import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:projeect/scanresult2.dart';
import 'package:projeect/scanresultpage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Add this import
import 'package:projeect/loginscreen2.dart' as Lgscreen;

// Replace with actual user ID logic
var user_id = Lgscreen.id_user; // Assuming id_user is set in loginscreen2.dart

Map<String, dynamic>? imagedata;

Future<void> _uploadImage(File imageFile) async {
  const String url = "https://mmm12212.pythonanywhere.com/send_image";
  try {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    // Use File.openRead to ensure the file is streamed correctly
    final fileStream = http.ByteStream(imageFile.openRead());
    final fileLength = await imageFile.length();

    final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      fileLength,
      filename: imageFile.path.split('/').last,
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(multipartFile);

    // Send user_id as a form field, always as a string
    request.fields['user_id'] = user_id != null ? user_id.toString() : '';

    print("Sending image and user_id to backend...");

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 200) {
      imagedata = json.decode(responseBody);
      print("✅ Data received:");
      print(imagedata);
    } else {
      print("❌ Error: ${streamedResponse.statusCode}");
      print(responseBody);
    }
  } catch (e) {
    print("🚨 Exception: $e");
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  // Remove flash mode state and animation related to flash
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      // Remove flash mode initialization
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Remove flash toggle function and icon getter

  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      final File imageFile = File(image.path);

      await _uploadImage(imageFile);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scanresult2(imageFile: imageFile),
          ),
        );
      }
    } catch (e) {
      print("🚨 Error capturing image: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Camera",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body:
          _isCameraInitialized
              ? Stack(
                children: [
                  // Camera Preview with rounded corners
                  Container(
                    margin: const EdgeInsets.only(top: 100, bottom: 150),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(_cameraController!),
                    ),
                  ),

                  // Top gradient overlay
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Bottom gradient overlay
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Remove flash mode indicator (top right)

                  // Camera controls
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Empty space for symmetry
                          const SizedBox(width: 50),

                          // Capture button (centered)
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale:
                                    _isCapturing ? 0.9 : _pulseAnimation.value,
                                child: GestureDetector(
                                  onTap: _captureImage,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient:
                                          _isCapturing
                                              ? LinearGradient(
                                                colors: [
                                                  Colors.grey.shade400,
                                                  Colors.grey.shade600,
                                                ],
                                              )
                                              : const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF6B35),
                                                  Color(0xFFFF8E53),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF6B35,
                                          ).withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child:
                                          _isCapturing
                                              ? const Center(
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Color(0xFFFF6B35)),
                                                  ),
                                                ),
                                              )
                                              : const Icon(
                                                Icons.camera_alt,
                                                size: 32,
                                                color: Color(0xFFFF6B35),
                                              ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Remove flash button from controls
                          const SizedBox(width: 50),
                        ],
                      ),
                    ),
                  ),

                  // Capture hint
                  if (!_isCapturing)
                    Positioned(
                      bottom: 140,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            "Tap to capture",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
              : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Initializing Camera...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
