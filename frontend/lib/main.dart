import 'package:flutter/material.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/dashboard/navigation_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SASShieldApp());
}

class SASShieldApp extends StatelessWidget {
  const SASShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAS Shield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E40AF),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA5B4FC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const SignInScreen(),
        '/dashboard': (context) => const NavigationWrapper(),
      },
    );
  }
}
