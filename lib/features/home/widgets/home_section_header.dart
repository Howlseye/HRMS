import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4.0),
            child: Row(
              children: [
                Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.bodySmallBold.copyWith(
                    color: AppColors.primaryBlueStart,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primaryBlueStart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
