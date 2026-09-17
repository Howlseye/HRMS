import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/success_screen.dart';

class AttendanceSuccessScreen extends StatelessWidget {
  final bool isCheckIn;
  final String date;
  final String timeRange;
  final String? alertMessage;

  const AttendanceSuccessScreen({
    super.key,
    required this.isCheckIn,
    required this.date,
    required this.timeRange,
    this.alertMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: isCheckIn ? AppStrings.checkInSent : AppStrings.checkOutSent,
      subtitleWidget: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              date,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              timeRange,
              style: AppTextStyles.titleSemiBold.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            if (alertMessage != null) ...[
              const SizedBox(height: 24),
              Text(
                isCheckIn ? AppStrings.checkInLate : AppStrings.checkOutEarly,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDanger,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                alertMessage!,
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.textDanger,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      buttonText: AppStrings.back,
      onButtonPressed: () => context.pop(),
      onClosePressed: () => context.pop(),
    );
  }
}
