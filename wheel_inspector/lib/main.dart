import 'package:flutter/material.dart';
import 'screens/wheel_detection_screen.dart';

void main() {
  runApp(const WheelInspectorApp());
}

class WheelInspectorApp extends StatelessWidget {
  const WheelInspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheel Inspector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WheelDetectionScreen(),
    );
  }
}
