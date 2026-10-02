import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/popup_cancel_icon.svg',
            height: 64,
            width: 78,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: AppTextStyles.titleBold.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlueStart,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              AppStrings.cobaLagi,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textWhite),
            ),
          ),
        ],
      ),
    );
  }
}
