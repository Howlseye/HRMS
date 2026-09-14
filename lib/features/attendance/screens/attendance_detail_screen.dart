import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/attendance_log_entry.dart';

class AttendanceDetailScreen extends StatelessWidget {
  final AttendanceLogEntry logEntry;

  const AttendanceDetailScreen({
    super.key,
    required this.logEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.detailAttendanceTitle,
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  logEntry.fullDate,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  logEntry.workingHours,
                  style: AppTextStyles.headingBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildDetailField(
                  label: AppStrings.checkIn,
                  value: logEntry.checkIn,
                  valueColor: logEntry.isLate ? AppColors.textDanger : AppColors.textPrimary,
                ),
                const SizedBox(height: 16),
                _buildDetailField(
                  label: AppStrings.checkOut,
                  value: logEntry.checkOut,
                  valueColor: logEntry.isEarlyOut ? AppColors.textDanger : AppColors.textPrimary,
                ),
                const SizedBox(height: 16),
                _buildDetailField(
                  label: AppStrings.reasonLate,
                  value: logEntry.lateReason ?? AppStrings.notLate,
                  isBoxed: true,
                  isPlaceholder: logEntry.lateReason == null,
                ),
                const SizedBox(height: 16),
                _buildDetailField(
                  label: AppStrings.reasonEarlyOut,
                  value: logEntry.earlyOutReason ?? AppStrings.notEarlyOut,
                  isBoxed: true,
                  isPlaceholder: logEntry.earlyOutReason == null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField({
    required String label,
    required String value,
    Color? valueColor,
    bool isBoxed = false,
    bool isPlaceholder = false,
  }) {
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
