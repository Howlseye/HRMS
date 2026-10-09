import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return '$dayName, ${now.day} ${monthName.substring(0, 3)} ${now.year}';
  }

  Widget _buildRowItem(String label, String value, {bool isLast = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.iconGray),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityStr = activities.join(', ');
    int totalWorkingDays = 20;
    int recordedCount = 3 + 1;
    double progress = totalWorkingDays > 0 ? recordedCount / totalWorkingDays : 0.0;
    
    return SuccessScreen(
      title: AppStrings.addLogBookSuccessTitle,
      lottieAsset: 'assets/lottie/success.json',
      buttonText: AppStrings.btnBack,
      onButtonPressed: () {
        context.go('/main');
      },
      onClosePressed: () {
        context.go('/main');
      },
      subtitleWidget: Column(
        children: [
          Text(
            _currentDate,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.iconGray),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.workingHoursFull,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.iconGray,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGreen),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: AppColors.menuBgBlue,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textSuccess),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${AppStrings.addLogBookSuccessProgressPrefix}$recordedCount/$totalWorkingDays',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSuccess,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildRowItem(AppStrings.addLogBookSuccessActivityLabel, activityStr),
                _buildRowItem(AppStrings.addLogBookSuccessDetailLabel, summary, isLast: constraint.isEmpty),
                if (constraint.isNotEmpty)
                  _buildRowItem(AppStrings.addLogBookSuccessConstraintLabel, constraint, isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
