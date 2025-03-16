import 'package:flutter/material.dart';

import 'package:google_gemini_ui/gemini_voice_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeminiVoiceUI(),
    );
  }
}