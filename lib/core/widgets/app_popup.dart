import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppPopup extends StatelessWidget {
  final String svgAsset;
  final Color iconColor;
  final String title;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;
  final Color primaryButtonColor;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const AppPopup({
    super.key,
    required this.svgAsset,
    this.iconColor = AppColors.primaryBlueStart,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.primaryButtonColor = AppColors.primaryBlueStart,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.bgWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                SvgPicture.asset(
                  svgAsset,
                  width: 52,
                  height: 52,
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: AppTextStyles.titleBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.iconGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.borderDivider,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (secondaryButtonText.isNotEmpty) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSecondaryPressed,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        secondaryButtonText,
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      primaryButtonText,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.bgWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
