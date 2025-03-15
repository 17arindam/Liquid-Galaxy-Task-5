import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gui_shape/gui_shape.dart';

class GeminiVoiceUI extends StatefulWidget {
  const GeminiVoiceUI({super.key});

  @override
  State<GeminiVoiceUI> createState() => _GeminiVoiceUIState();
}

class _GeminiVoiceUIState extends State<GeminiVoiceUI>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _rotationController;

  late Animation<Color?> _startColor;
  late Animation<Color?> _middleColor;
  late Animation<Color?> _endColor;

  final List<_ShapeConfig> _shapes = [
    _ShapeConfig.circle(),
    _ShapeConfig.star(),
    _ShapeConfig.stadium(),
    _ShapeConfig.hexagon(),
    _ShapeConfig.circle(),
    _ShapeConfig.star(),
    _ShapeConfig.stadium(),
    _ShapeConfig.hexagon(),
    _ShapeConfig.circle(),
  ];

  int _currentShapeIndex = 0;
  bool _isAnimating = false;
  bool _showShape = false;
  String _currentImage = 'assets/gemini_dark_theme.png';
  Timer? _shapeChangeTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _startColor = ColorTween(
      begin: const Color(0xFF9168C0),
      end: const Color(0xFF5684D1),
    ).animate(_gradientController);

    _middleColor = ColorTween(
      begin: const Color(0xFF5684D1),
      end: const Color.fromARGB(255, 51, 187, 255),
    ).animate(_gradientController);

    _endColor = ColorTween(
      begin: const Color.fromARGB(255, 51, 187, 255),
      end: const Color(0xFF9168C0),
    ).animate(_gradientController);
  }

  @override
  void dispose() {
    _shapeChangeTimer?.cancel();
    _gradientController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _showShape = false;
      _currentImage = 'assets/gemini_original.png';
      _currentShapeIndex = 0;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentImage = 'assets/gemini_light_theme.png';
        _showShape = true;
      });

      _gradientController.reset();
      _rotationController.reset();
      _rotationController.forward();
      _gradientController.repeat();
      _scheduleShapeChanges();
    });
  }

  void _scheduleShapeChanges() {
    _shapeChangeTimer?.cancel();
    _shapeChangeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentShapeIndex >= _shapes.length - 1) {
        _endAnimation();
        timer.cancel();
      } else {
        setState(() {
          _currentShapeIndex++;
        });
      }
    });
  }

  void _endAnimation() {
    setState(() {
      _isAnimating = false;
      _showShape = false;
      _currentImage = 'assets/gemini_original.png';
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentImage = 'assets/gemini_dark_theme.png';
      });
    });

    _shapeChangeTimer?.cancel();
    _rotationController.reset();
    _gradientController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(!_isAnimating)
            const Text(
              "Click on the Gemini icon",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16), // Add spacing between text and icon
            GestureDetector(
              onTap: _startAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_showShape) _buildShapeContainer(),
                  AnimatedRotation(
                    turns: _isAnimating ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      _currentImage,
                      height: 90,
                      width: 90,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeContainer() {
    return RotationTransition(
      turns: _rotationController,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: 200,
        width: _shapes[_currentShapeIndex].isWider ? 250 : 200,
        decoration: ShapeDecoration(
          shape: _shapes[_currentShapeIndex].shape,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _startColor.value ?? Colors.purple,
              _middleColor.value ?? Colors.blue,
              _endColor.value ?? Colors.cyan,
            ],
          ),
        ),
      ),
    );
  }
}

class _ShapeConfig {
  final dynamic shape;
  final bool isWider;

  const _ShapeConfig({required this.shape, this.isWider = false});

  factory _ShapeConfig.circle() => _ShapeConfig(
        shape: GuiShapeBorder(
          shape: GuiShapePolygon(
            sides: 6,
            startAngle: GeoAngle(degree: 0),
            cornerRadius: 30,
          ),
        ),
      );

  factory _ShapeConfig.star() => _ShapeConfig(
        shape: GuiShapeBorder(
          shape: GuiShapeStar(
            sides: 8,
            cornerRadius: 20,
            startAngle: GeoAngle(degree: 0),
            clockwise: true,
            boxFit: BoxFit.fill,
            indentSideFactor: 0.7,
          ),
        ),
      );

  factory _ShapeConfig.stadium() => _ShapeConfig(
        shape: const StadiumBorder(),
        isWider: true,
      );

  factory _ShapeConfig.hexagon() => _ShapeConfig(
        shape: GuiShapeBorder(
          shape: GuiShapePolygon(
            sides: 6,
            startAngle: GeoAngle(degree: 0),
            cornerRadius: 12,
          ),
        ),
      );
}
