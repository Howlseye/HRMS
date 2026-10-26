import 'package:absensi/core/constants/app_assets.dart';
import 'package:absensi/core/constants/app_strings.dart';
import 'package:absensi/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final sid = prefs.getString('sid');
      final isRememberMe = prefs.getBool('is_remember_me') ?? false;

      if (sid != null && sid.isNotEmpty && isRememberMe) {
        context.go('/main');
      } else {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Image.asset(
                AppAssets.appLogo,
                 scale: 0.8,
              ),
              Text(
                AppStrings.appName,
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.primaryBlueStart,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.appSubtitle,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Lottie.asset(
                AppAssets.loadingLottie,
                width: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
