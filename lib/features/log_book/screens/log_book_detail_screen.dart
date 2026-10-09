import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/log_book_entry.dart';

class LogBookDetailScreen extends StatelessWidget {
  final LogBookEntry logEntry;

  const LogBookDetailScreen({
    super.key,
    required this.logEntry,
  });

  String _getStatusTitle() {
    switch (logEntry.status.toLowerCase()) {
      case 'rejected':
        return AppStrings.leaveRejected;
      case 'approved':
        return AppStrings.leaveApproved;
      case 'waiting':
        return AppStrings.waitingApproval;
      default:
        return AppStrings.detailLogTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.detailLogTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.menuBgBlue,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        logEntry.date,
                        style: AppTextStyles.titleBold.copyWith(
                          color: AppColors.primaryBlueStart,
                        ),
                      ),
                      const Icon(
                        Icons.date_range,
                        color: AppColors.primaryBlueStart,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _getStatusTitle(),
                    style: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.checkInOut,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.iconGray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${logEntry.checkInTime} - ${logEntry.checkOutTime}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.iconNavy,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),


                _buildDetailColumn(AppStrings.activity, logEntry.activities),


                _buildDetailColumn(AppStrings.detail, logEntry.detail),


                _buildDetailColumn(AppStrings.constraints, logEntry.constraints),


                if (logEntry.status.toLowerCase() == 'rejected' && logEntry.rejectReason != null)
                  _buildDetailColumn(
                    AppStrings.rejectReasonLabel,
                    logEntry.rejectReason!,
                    isError: true,
                    isLast: true,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, {bool isError = false, bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.iconGray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isError ? AppColors.textDanger : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: AppColors.borderLight, height: 1),
      ],
    );
  }
}
