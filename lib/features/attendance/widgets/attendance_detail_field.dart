import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AttendanceDetailField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBoxed;
  final bool isPlaceholder;

  const AttendanceDetailField({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBoxed = false,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: isBoxed ? 96.0 : 0.0),
          padding: isBoxed ? const EdgeInsets.all(12) : EdgeInsets.zero,
          decoration: isBoxed
              ? BoxDecoration(
                  color: AppColors.menuBgGray,
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(6),
                )
              : null,
          child: Text(
            value,
            style: AppTextStyles.title.copyWith(
              color: valueColor ?? (isPlaceholder ? AppColors.iconDisabled : AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
