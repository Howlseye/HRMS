import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

enum SnackbarType { success, error, info }

class AppSnackbar {
  static OverlayEntry? _currentOverlay;

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

    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) return;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final bottomOffset = mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom + 24;
        return Positioned(
          bottom: bottomOffset,
          left: 16,
          right: 16,
          child: Material(
            color: AppColors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textDark.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
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
            ),
          ),
        );
      },
    );

    _currentOverlay = overlayEntry;
    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      if (_currentOverlay == overlayEntry) {
        overlayEntry.remove();
        _currentOverlay = null;
      }
    });
  }
}
