import 'dart:async';

import 'package:flutter/material.dart';

import '../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Enhancement 1: Persistent authentication on splash screen
  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final loggedIn = await _userService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      final userData = await _userService.getUserData();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home', arguments: userData);
      return;
    }

    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/NUBDEXCHANGE_LOGO.PNG',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              const Text(
                'NUBD Exchange',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F3E5C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
