import 'package:flutter/material.dart';
import 'UI/homescreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SyntheticAudioShieldApp());
}

class SyntheticAudioShieldApp extends StatelessWidget {
  const SyntheticAudioShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synthetic Audio Shield',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
