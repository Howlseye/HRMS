import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class AttendanceActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String time;
  final Color? iconColor;
  final Color? iconBgColor;
  final bool isTimeWarning;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AttendanceActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.time,
    this.iconColor,
    this.iconBgColor,
    this.isTimeWarning = false,
    this.margin = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: iconBgColor ?? AppColors.menuBgBlue,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primaryBlueStart,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.headingSmall.copyWith(
              color: isTimeWarning ? AppColors.textDanger : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    ),
  ),
),
    );
  }
}
