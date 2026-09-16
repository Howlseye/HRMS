import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

enum LeaveStatus { waiting, approved, rejected }

class LeaveCard extends StatelessWidget {
  final String title;
  final LeaveStatus status;
  final String statusDate;
  final String leaveType;
  final String dateRange;
  final VoidCallback? onTap;

  const LeaveCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusDate,
    required this.leaveType,
    required this.dateRange,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case LeaveStatus.waiting:
        return AppColors.iconYellow;
      case LeaveStatus.approved:
        return AppColors.textSuccess;
      case LeaveStatus.rejected:
        return AppColors.textDanger;
    }
  }

  Color _getStatusBgColor() {
    switch (status) {
      case LeaveStatus.waiting:
        return AppColors.menuBgOrangeLight;
      case LeaveStatus.approved:
        return AppColors.menuBgGreen;
      case LeaveStatus.rejected:
        return AppColors.menuBgPink;
    }
  }

  String _getStatusText() {
    switch (status) {
      case LeaveStatus.waiting:
        return AppStrings.statusWaiting;
      case LeaveStatus.approved:
        return AppStrings.statusApproved;
      case LeaveStatus.rejected:
        return AppStrings.statusRejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMediumBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(),
                  border: Border.all(color: _getStatusColor()),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  _getStatusText(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            statusDate,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.iconDisabled,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.filterChipBgActive,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.leaveType,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        leaveType,
                        style: AppTextStyles.bodySmallBold.copyWith(
                          color: AppColors.filterChipBorderActive,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.leaveDate,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        dateRange,
                        style: AppTextStyles.bodySmallBold.copyWith(
                          color: AppColors.filterChipBorderActive,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}


