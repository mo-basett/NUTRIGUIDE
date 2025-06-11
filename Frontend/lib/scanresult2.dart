import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/splashview.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:projeect/camerapage.dart' as scan;

class Scanresult2 extends StatefulWidget {
  final File imageFile;

  const Scanresult2({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<Scanresult2> createState() => _Analysis2State();
}

class _Analysis2State extends State<Scanresult2> with TickerProviderStateMixin {
  bool _showAllNutrition = false;
  bool _showAllRecipes = false;
  bool _showAllHealthInfo = false;

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _staggerController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _staggerAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    _staggerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _staggerController, curve: Curves.easeOutCubic),
    );

    // Start animations with delays
    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(Duration(milliseconds: 100));
    _scaleController.forward();
    await Future.delayed(Duration(milliseconds: 150));
    _staggerController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  // Standardized text styles
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
    fontFamily: 'Roboto',
    letterSpacing: -0.5,
  );

  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF4A5568),
    fontFamily: 'Roboto',
    height: 1.5,
  );

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
    fontFamily: 'Roboto',
    letterSpacing: 0.2,
  );

  static const TextStyle _buttonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF3B82F6),
    fontFamily: 'Roboto',
  );

  List<Map<String, String>> _parseNutritionInfo(String rawInfo) {
    final lines =
        rawInfo.split('\n').where((line) => line.contains(':')).toList();
    return lines.map((line) {
      final parts = line.split(':');
      return {
        'label': parts[0].replaceAll(RegExp(r'^[^\w]+|\*$'), '').trim(),
        'value': parts.sublist(1).join(':').trim(),
      };
    }).toList();
  }

  Map<String, String> _extractMainNutrients(
    List<Map<String, String>> contents,
  ) {
    Map<String, String> nutrients = {
      'calories': '0',
      'protein': '0g',
      'carbs': '0g',
      'fats': '0g',
    };
    for (var item in contents) {
      String label = item['label']!.toLowerCase();
      String value = item['value']!;

      if (label.contains('calorie') || label.contains('energy')) {
        nutrients['calories'] = value.replaceAll(RegExp(r'[^0-9]'), '');
      } else if (label.contains('protein')) {
        nutrients['protein'] = value;
      } else if (label.contains('carb') || label.contains('carbohydrate')) {
        nutrients['carbs'] = value;
      } else if (label.contains('fat') || label.contains('lipid')) {
        nutrients['fats'] = value;
      }
    }
    return nutrients;
  }

  List<String> _extractDietaryInfo(String infoText) {
    List<String> dietaryInfo = [];
    String lowerInfo = infoText.toLowerCase();

    if (lowerInfo.contains('vegetarian') || lowerInfo.contains('plant')) {
      dietaryInfo.add('Vegetarian');
    }
    if (lowerInfo.contains('gluten free') ||
        lowerInfo.contains('gluten-free')) {
      dietaryInfo.add('Gluten Free');
    }
    if (lowerInfo.contains('vegan') || lowerInfo.contains('plant-based')) {
      dietaryInfo.add('Plant-Based');
    }
    if (lowerInfo.contains('dairy free') || lowerInfo.contains('dairy-free')) {
      dietaryInfo.add('Dairy Free');
    }

    return dietaryInfo;
  }

  String _extractAllergenInfo(String infoText) {
    String lowerInfo = infoText.toLowerCase();
    List<String> allergens = [];

    if (lowerInfo.contains('nuts') || lowerInfo.contains('peanut')) {
      allergens.add('nuts');
    }
    if (lowerInfo.contains('sesame')) {
      allergens.add('sesame seeds');
    }
    if (lowerInfo.contains('dairy') || lowerInfo.contains('milk')) {
      allergens.add('dairy');
    }
    if (lowerInfo.contains('egg')) {
      allergens.add('eggs');
    }
    if (lowerInfo.contains('soy')) {
      allergens.add('soy');
    }

    if (allergens.isNotEmpty) {
      return 'May contain traces of ${allergens.join(', ')}';
    }
    return 'No known allergens detected';
  }

  Widget _buildAnimatedContainer({
    required Widget child,
    required double width,
    EdgeInsets? padding,
    List<Color>? gradientColors,
    Color? backgroundColor,
    double? borderRadius,
    required int animationIndex,
  }) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        final delay = animationIndex * 0.1;
        final animationValue = Curves.easeOutCubic.transform(
          (_staggerController.value - delay).clamp(0.0, 1.0),
        );

        return Transform.translate(
          offset: Offset(0, 30 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              width: width,
              padding: padding ?? EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient:
                    gradientColors != null
                        ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors,
                        )
                        : null,
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(borderRadius ?? 24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: child!,
            ),
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildDietaryTag(String label, IconData icon, Color color) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      constraints: BoxConstraints(maxWidth: 170),
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: FaIcon(icon, size: 18, color: color),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getImageUrlForWeb(File imageFile) {
    return imageFile.path;
  }

  Widget _buildExpandableText(
    String text,
    bool isExpanded,
    VoidCallback onToggle,
    int maxLines,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Text(
            text,
            style: _bodyStyle,
            maxLines: isExpanded ? null : maxLines,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isExpanded ? 'Show Less' : 'Show More',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(width: 8),
                      AnimatedRotation(
                        duration: Duration(milliseconds: 300),
                        turns: isExpanded ? 0.5 : 0,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth - 32;

    final imageData = scan.imagedata;
    final foodName = imageData?['Predicted_label'] ?? 'Unknown Food';
    final nutritionRaw = imageData?['Nutrition_info'] ?? '';
    final List<Map<String, String>> contents = _parseNutritionInfo(
      nutritionRaw,
    );
    final infoText = imageData?['Information'] ?? '';
    final recipes = imageData?['Recipes'] ?? '';

    final mainNutrients = _extractMainNutrients(contents);
    final dietaryInfo = _extractDietaryInfo(infoText);
    final allergenInfo = _extractAllergenInfo(infoText);

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF12372A)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ),
          ),
        ),
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'Scan Result',
            style: TextStyle(
              color: Color(0xFF12372A),
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Food Image and Name Section
                _buildAnimatedContainer(
                  width: containerWidth,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  animationIndex: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'food_image_${widget.imageFile.path}',
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            child:
                                kIsWeb
                                    ? Image.network(
                                      _getImageUrlForWeb(widget.imageFile),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error, size: 50),
                                    )
                                    : Image.file(
                                      widget.imageFile,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error, size: 50),
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 600),
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  foodName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    letterSpacing: -0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  dietaryInfo.isNotEmpty
                                      ? dietaryInfo.join(' • ')
                                      : 'Nutritious Food',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.9),
                                    fontFamily: 'Roboto',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Nutrition Facts Section
                _buildAnimatedContainer(
                  width: containerWidth,
                  gradientColors: [Colors.white, Color(0xFFF8FAFC)],
                  animationIndex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.analytics_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Nutrition Facts', style: _titleStyle),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNutrientCircle(
                            mainNutrients['calories']!,
                            'Calories',
                            [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                            0,
                          ),
                          _buildNutrientCircle(
                            mainNutrients['protein']!,
                            'Protein',
                            [Color(0xFF10B981), Color(0xFF059669)],
                            1,
                          ),
                          _buildNutrientCircle(
                            mainNutrients['carbs']!,
                            'Carbs',
                            [Color(0xFFEF4444), Color(0xFFDC2626)],
                            2,
                          ),
                          _buildNutrientCircle(mainNutrients['fats']!, 'Fats', [
                            Color(0xFFF59E0B),
                            Color(0xFFD97706),
                          ], 3),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Detailed Nutrition Information
                if (contents.isNotEmpty)
                  _buildAnimatedContainer(
                    width: containerWidth,
                    backgroundColor: Colors.white,
                    animationIndex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8B5CF6),
                                    Color(0xFF7C3AED),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.list_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Detailed Nutrition', style: _titleStyle),
                          ],
                        ),
                        SizedBox(height: 20),
                        AnimatedSize(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _showAllNutrition ? contents.length : 3,
                            itemBuilder: (context, index) {
                              if (index >= contents.length)
                                return SizedBox.shrink();
                              final item = contents[index];
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item['label']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF374151),
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item['value']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if (contents.length > 3)
                          Center(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              margin: EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8B5CF6),
                                    Color(0xFF7C3AED),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap:
                                      () => setState(
                                        () =>
                                            _showAllNutrition =
                                                !_showAllNutrition,
                                      ),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _showAllNutrition
                                              ? 'Show Less'
                                              : 'Show More',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        AnimatedRotation(
                                          duration: Duration(milliseconds: 300),
                                          turns: _showAllNutrition ? 0.5 : 0,
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                SizedBox(height: 20),

                // Recipes Section
                if (recipes.isNotEmpty)
                  _buildAnimatedContainer(
                    width: containerWidth,
                    backgroundColor: Colors.white,
                    animationIndex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF59E0B),
                                    Color(0xFFD97706),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.restaurant_menu,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Recipe Ingredients', style: _titleStyle),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildExpandableText(
                          recipes,
                          _showAllRecipes,
                          () => setState(
                            () => _showAllRecipes = !_showAllRecipes,
                          ),
                          3,
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 20),

                // Health Benefits Section
                if (infoText.isNotEmpty)
                  _buildAnimatedContainer(
                    width: containerWidth,
                    backgroundColor: Colors.white,
                    animationIndex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFEF4444),
                                    Color(0xFFDC2626),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.health_and_safety,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Health Benefits & Considerations',
                              style: _titleStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildExpandableText(
                          infoText,
                          _showAllHealthInfo,
                          () => setState(
                            () => _showAllHealthInfo = !_showAllHealthInfo,
                          ),
                          4,
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientCircle(
    String value,
    String label,
    List<Color> gradientColors,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        final delay = index * 0.15;
        final animationValue = Curves.elasticOut.transform(
          (_staggerController.value - delay).clamp(0.0, 1.0),
        );

        return Transform.scale(
          scale: animationValue,
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.bounceOut,
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 400),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                    child: Text(value, textAlign: TextAlign.center),
                  ),
                ),
              ),
              SizedBox(height: 12),
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 400),
                style: _labelStyle,
                child: Text(label),
              ),
            ],
          ),
        );
      },
    );
  }
}
