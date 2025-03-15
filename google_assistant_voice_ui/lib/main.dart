import 'package:flutter/material.dart';
import 'package:google_assistant_voice_ui/google_voice_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleVoiceUI(),
    );
  }
}
