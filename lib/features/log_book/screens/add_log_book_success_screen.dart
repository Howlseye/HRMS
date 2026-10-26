import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/success_screen.dart';

class AddLogBookSuccessScreen extends StatelessWidget {
  final List<String> activities;
  final String summary;
  final String constraint;

  const AddLogBookSuccessScreen({
    super.key,
    required this.activities,
    required this.summary,
    required this.constraint,
  });

  String get _currentDate {
    final now = DateTime.now();
    final dayNames = AppStrings.shortDayNames;
    final dayName = dayNames[now.weekday - 1];
    final monthName = AppStrings.monthNames[now.month - 1];
    return '$dayName, ${now.day} $monthName ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: AppStrings.submitLogBookSuccessTitle,
      lottieAsset: AppAssets.successLottie,
      buttonText: AppStrings.checkOut,
      onButtonPressed: () {
        context.go('/main');
      },
      onClosePressed: () {
        context.go('/attendance-log');
      },
      subtitleWidget: Column(
        children: [
          Text(
            _currentDate,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              AppStrings.submitLogBookSuccessMsg,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
