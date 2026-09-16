import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';

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
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    context.go('/main');
                  },
                ),
              ),
            ),
            
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/success.svg',
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isCheckIn ? AppStrings.checkInSent : AppStrings.checkOutSent,
                        style: AppTextStyles.displayMediumBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
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
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: CustomButton(
                text: AppStrings.back,
                onPressed: () {
                  context.go('/main');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
