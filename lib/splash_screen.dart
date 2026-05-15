import 'dart:async';

import 'package:flutter/material.dart';

import 'screens/auth/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    await AuthService.instance.initialize();
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    final currentUser = await AuthService.instance.getCurrentUser();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => currentUser != null
            ? HomeScreen(userName: currentUser.name)
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A9BFD),
              Color(0xFF1E88E5),
              Color(0xFF00C6FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/logo1.jpeg',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 24),
                  Image.asset(
                    'images/logo2.png',
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Physic Lab",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
