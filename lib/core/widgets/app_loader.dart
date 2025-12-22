import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSplashScreen();
        }

        final isLoggedIn = snapshot.data ?? false;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            isLoggedIn ? AppRoutes.home : AppRoutes.login,
          );
        });

        return Container(color: const Color(0xFF0A3C3A));
      },
    );
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3C3A),
      body: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
