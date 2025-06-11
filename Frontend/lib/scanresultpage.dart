import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:projeect/camerapage.dart' as scan;

class ScanResultPage extends StatefulWidget {
  final File? imageFile;

  const ScanResultPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _showAll = false;

  List<Map<String, String>> _parseNutritionInfo(String rawInfo) {
    final lines =
        rawInfo.split('\n').where((line) => line.contains(':')).toList();
    return lines.map((line) {
      final parts = line.split(':');
      return {
        'label': parts[0].replaceAll(RegExp(r'^[^\w]+|\*$'), '').trim(),
        'value': parts.sublist(1).join(':').trim(),
        'color': 'black',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final imageData = scan.imagedata;
    final foodName = imageData?['Predicted_label'] ?? 'Unknown Food';
    final nutritionRaw = imageData?['Nutrition_info'] ?? '';
    final List<Map<String, String>> contents = _parseNutritionInfo(
      nutritionRaw,
    );
    final infoText = imageData?['Information'] ?? '';
    final recipes = imageData?['Recipes'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xff12372A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Vegetablesset05.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    foodName,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: ClipOval(
                    child:
                        kIsWeb
                            ? Image.network(
                              _getImageUrlForWeb(widget.imageFile!),
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.error, size: 50),
                            )
                            : Image.file(
                              widget.imageFile!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.error, size: 50),
                            ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Contents:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            contents.isEmpty
                ? const Text(
                  'No nutrition information available.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _showAll ? contents.length : 5,
                  itemBuilder: (context, index) {
                    final item = contents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${index + 1}. ${item['label']}: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getColor(item['color']!),
                              ),
                            ),
                            TextSpan(
                              text: item['value'],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _showAll = !_showAll),
                icon: Icon(_showAll ? Icons.expand_less : Icons.expand_more),
                label: Text(
                  _showAll ? 'Show Less' : 'Show More',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Recipe Ingredients'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(recipes, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Benefits & Considerations:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(infoText, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImageUrlForWeb(File imageFile) {
    return imageFile.path;
  }

  Color _getColor(String color) {
    switch (color.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'brown':
        return Colors.brown;
      default:
        return Colors.black;
    }
  }
}
