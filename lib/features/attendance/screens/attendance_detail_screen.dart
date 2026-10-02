import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/attendance_log_entry.dart';
import '../providers/attendance_log_provider.dart';
import '../widgets/attendance_detail_field.dart';
import '../../../core/widgets/custom_loading_indicator.dart';

class AttendanceDetailScreen extends ConsumerWidget {
  final AttendanceLogEntry logEntry;

  const AttendanceDetailScreen({
    super.key,
    required this.logEntry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(attendanceDetailProvider(logEntry));

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.detailAttendanceTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
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
                AttendanceDetailField(
                  label: AppStrings.checkIn,
                  value: logEntry.checkIn,
                  valueColor: logEntry.isLate ? AppColors.textDanger : AppColors.textPrimary,
                ),
                const SizedBox(height: 16),
                AttendanceDetailField(
                  label: AppStrings.checkOut,
                  value: logEntry.checkOut,
                  valueColor: logEntry.isEarlyOut ? AppColors.textDanger : AppColors.textPrimary,
                ),
                const SizedBox(height: 16),
                
                detailAsync.when(
                  data: (reasons) {
                    final lateReason = logEntry.isLate 
                        ? (reasons['lateReason'] != null && reasons['lateReason']!.isNotEmpty ? reasons['lateReason']! : AppStrings.noReason)
                        : AppStrings.notLate;
                        
                    final earlyOutReason = logEntry.isEarlyOut
                        ? (reasons['earlyOutReason'] != null && reasons['earlyOutReason']!.isNotEmpty ? reasons['earlyOutReason']! : AppStrings.noReason)
                        : AppStrings.notEarlyOut;

                    return Column(
                      children: [
                        AttendanceDetailField(
                          label: AppStrings.reasonLate,
                          value: lateReason,
                          isBoxed: true,
                          isPlaceholder: lateReason == AppStrings.noReason || lateReason == AppStrings.notLate,
                        ),
                        const SizedBox(height: 16),
                        AttendanceDetailField(
                          label: AppStrings.reasonEarlyOut,
                          value: earlyOutReason,
                          isBoxed: true,
                          isPlaceholder: earlyOutReason == AppStrings.noReason || earlyOutReason == AppStrings.notEarlyOut,
                        ),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: CustomLoadingIndicator()),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text(
                        AppStrings.errorLoadData,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDanger),
                      ),
                    ),
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
