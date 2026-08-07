import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'About SAS Shield',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.hammer_fill,
                size: 48,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'About SAS Shield coming soon. Stay tuned for updates!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
