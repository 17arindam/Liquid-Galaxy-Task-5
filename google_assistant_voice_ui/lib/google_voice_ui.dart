import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class GoogleVoiceUI extends StatefulWidget {
  const GoogleVoiceUI({super.key});

  @override
  _GoogleVoiceUIState createState() => _GoogleVoiceUIState();
}

class _GoogleVoiceUIState extends State<GoogleVoiceUI> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  Timer? _stopTimer;
  String _recognizedText = "";
  final ScrollController _scrollController = ScrollController();
  bool _isBottomSheetOpen = false;

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == "done" || status == "notListening") {
            _stopListening();
            if (_isBottomSheetOpen && mounted) {
              Navigator.of(context).pop();
            }
          }
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _recognizedText = "";
        });
        _showBottomSheet();
        _speech.listen(
          onResult: (result) {
            if (mounted && result.recognizedWords.isNotEmpty) {
              setState(() {
                _recognizedText = result.recognizedWords;
              });
              if (_isBottomSheetOpen) {
                _updateBottomSheetContent();
              }
              _scrollToEnd();
            }
            _resetStopTimer();
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          
        );

        _resetStopTimer();
      } else {
        
      }
    } else {
      _stopListening();
    }
  }

  void _updateBottomSheetContent() {
    if (_bottomSheetSetState != null) {
      _bottomSheetSetState!(() {});
    }
  }

  StateSetter? _bottomSheetSetState;

  void _showBottomSheet() {
    setState(() {
      _isBottomSheetOpen = true;
    });

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: const Color(0xff01172F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            _bottomSheetSetState = setModalState;

            return WillPopScope(
              onWillPop: () async {
                _stopListening();
                setState(() {
                  _isBottomSheetOpen = false;
                });
                return true;
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                   
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Center(
                              child: Text(
                                _recognizedText.isEmpty
                                    ? ""
                                    : _recognizedText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedVoiceBar(
                        isListening: _isListening,
                        maxWidth: MediaQuery.of(context).size.width * 0.8),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      // When bottom sheet is closed
      _bottomSheetSetState = null;
      if (_isListening) {
        _stopListening();
      }
      setState(() {
        _isBottomSheetOpen = false;
      });
    });
  }

  void _resetStopTimer() {
    _stopTimer?.cancel();
    _stopTimer = Timer(const Duration(seconds: 5), () {
      _stopListening();
      // Close bottom sheet when listening stops
      if (_isBottomSheetOpen && mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
      _stopTimer?.cancel();
    }
  }

  void _scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _stopTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff03214A),
      body: Center(
        child: GestureDetector(
          onTap: _isBottomSheetOpen ? null : _toggleListening,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.mic_none_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedVoiceBar extends StatefulWidget {
  final bool isListening;
  final double maxWidth;

  const AnimatedVoiceBar(
      {Key? key, required this.isListening, required this.maxWidth})
      : super(key: key);

  @override
  State<AnimatedVoiceBar> createState() => _AnimatedVoiceBarState();
}

class _AnimatedVoiceBarState extends State<AnimatedVoiceBar>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final int containerCount = 4;
  late List<double> _widths;
  late List<Color> colors;
  Timer? _timer;

  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    colors = const [
      Color(0xFF4285F4),
      Color(0xFFEA4335),
      Color(0xFFFBCB05),
      Color(0xFF34A853)
    ];

    _widths =
        List.generate(containerCount, (_) => widget.maxWidth / containerCount);

    _controllers = List.generate(
      containerCount,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _animations = List.generate(
      containerCount,
      (index) => Tween<double>(
        begin: 0,
        end: _widths[index],
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ),
      ),
    );
    _updateAnimations();
  }

  void _updateAnimations() {
    for (int i = 0; i < containerCount; i++) {
      _animations[i] = Tween<double>(
        begin: _animations[i].value,
        end: widget.isListening ? _widths[i] : 0,
      ).animate(
        CurvedAnimation(
          parent: _controllers[i],
          curve: Curves.easeInOut,
        ),
      );

      _controllers[i].reset();
      _controllers[i].forward();
    }
    if (widget.isListening) {
      _startAnimation();
    } else {
      _timer?.cancel();
    }
  }

  void _startAnimation() {
    _timer?.cancel();

    _randomizeWidths();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && widget.isListening) {
        _randomizeWidths();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _randomizeWidths() {
    if (!mounted) return;

    double firstWidth = _random.nextDouble() * (widget.maxWidth * 0.6);
    double remainingWidth = widget.maxWidth - firstWidth;
    List<double> tempWidths = [firstWidth];

    for (int i = 1; i < containerCount; i++) {
      double partWidth = remainingWidth / (containerCount - i);
      tempWidths.add(partWidth);
      remainingWidth -= partWidth;
    }

    tempWidths.shuffle();
    _widths = tempWidths;

    for (int i = 0; i < containerCount; i++) {
      _animations[i] = Tween<double>(
        begin: _animations[i].value,
        end: widget.isListening ? _widths[i] : 0,
      ).animate(
        CurvedAnimation(
          parent: _controllers[i],
          curve: Curves.easeInOut,
        ),
      );

      _controllers[i].reset();
      _controllers[i].forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedVoiceBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      _updateAnimations();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(containerCount, (index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Container(
                width: _animations[index].value,
                height: 5.0,
              
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      index == 0 || index == containerCount - 1 ? 12 : 8),
                  color: colors[index],
                  boxShadow: widget.isListening
                      ? [
                          BoxShadow(
                            color: colors[index].withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 25,
                          )
                        ]
                      : [],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
