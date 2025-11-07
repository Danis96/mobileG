import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_assets.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Genie logo (gradient icon)
            Image.asset(
              AppAssets.genieIcon,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),
            // mihFIBER text logo
            Image.asset(
              AppAssets.fiberIcon,
              width: 280,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
