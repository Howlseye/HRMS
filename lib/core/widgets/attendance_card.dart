import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

class AttendanceCard extends StatelessWidget {
  final bool transparentBackground;

  const AttendanceCard({
    super.key,
    this.transparentBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: transparentBackground ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24.0),
      padding: transparentBackground ? const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0) : const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: transparentBackground
          ? null
          : BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlueStart,
            AppColors.primaryBlueEnd,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.date,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.workHours,
            style: AppTextStyles.headingExtraBold.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.login,
                  label: AppStrings.checkIn,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.logout,
                  label: AppStrings.checkOut,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check,
                color: AppColors.textWhite,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.alreadyCheckedOut,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.bgWhite,
        disabledBackgroundColor: AppColors.buttonDisabled,
        foregroundColor: AppColors.primaryBlueStart,
        disabledForegroundColor: AppColors.iconDisabled,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: AppTextStyles.headingSmall,
      ),
    );
  }
}
