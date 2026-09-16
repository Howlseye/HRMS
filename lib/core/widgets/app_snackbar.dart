import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

enum SnackbarType { success, error, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppColors.textSuccess;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = AppColors.textDanger;
        icon = Icons.error_outline;
        break;
      case SnackbarType.info:
        backgroundColor = AppColors.textPrimary;
        icon = Icons.info_outline;
        break;
    }

    final snackBar = SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textWhite, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textWhite),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      elevation: 6,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
