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
            if (timeRange.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                timeRange,
                style: AppTextStyles.titleSemiBold.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
            if (isCheckIn) ...[
              const SizedBox(height: 32),
              Text(
                AppStrings.selamatBekerja,
                style: AppTextStyles.titleBold.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppStrings.checkInSuccessDesc,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
      buttonText: isCheckIn ? AppStrings.dailyLogTitle : AppStrings.back,
      onButtonPressed: () {
        if (isCheckIn) {
          context.push('/add-log-book');
        } else {
          context.pop();
        }
      },
      onClosePressed: () => context.pop(),
    );
  }
}
