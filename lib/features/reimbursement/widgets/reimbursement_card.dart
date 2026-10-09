import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/reimbursement_model.dart';

class ReimbursementCard extends StatelessWidget {
  final String title;
  final ReimbursementStatus status;
  final String date;
  final List<ReimbursementItemModel> items;
  final VoidCallback? onTap;

  const ReimbursementCard({
    super.key,
    required this.title,
    required this.status,
    required this.date,
    required this.items,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case ReimbursementStatus.draft:
        return AppColors.iconYellow;
      case ReimbursementStatus.submitted:
        return AppColors.primaryBlueStart;
      case ReimbursementStatus.paid:
        return AppColors.textSuccess;
      case ReimbursementStatus.unpaid:
        return AppColors.iconPurple;
      case ReimbursementStatus.cancelled:
        return AppColors.iconGray;
      case ReimbursementStatus.rejected:
        return AppColors.textDanger;
    }
  }

  Color _getStatusBgColor() {
    switch (status) {
      case ReimbursementStatus.draft:
        return AppColors.menuBgOrangeLight;
      case ReimbursementStatus.submitted:
        return AppColors.menuBgBlue;
      case ReimbursementStatus.paid:
        return AppColors.menuBgGreen;
      case ReimbursementStatus.unpaid:
        return AppColors.menuBgLavender;
      case ReimbursementStatus.cancelled:
        return AppColors.menuBgGray;
      case ReimbursementStatus.rejected:
        return AppColors.menuBgPink;
    }
  }

  String _getStatusText() {
    switch (status) {
      case ReimbursementStatus.draft:
        return AppStrings.reimburseStatusDraft;
      case ReimbursementStatus.submitted:
        return AppStrings.reimburseStatusSubmitted;
      case ReimbursementStatus.cancelled:
        return AppStrings.reimburseStatusCancelled;
      case ReimbursementStatus.paid:
        return AppStrings.reimburseStatusPaid;
      case ReimbursementStatus.unpaid:
        return AppStrings.reimburseStatusUnpaid;
      case ReimbursementStatus.rejected:
        return AppStrings.reimburseStatusRejected;
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
                StatusBadge(
                  text: _getStatusText(),
                  textColor: _getStatusColor(),
                  backgroundColor: _getStatusBgColor(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date,
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
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == items.length - 1;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              AppCurrencyFormatter.format(item.amount),
                              style: AppTextStyles.bodySmallBold.copyWith(
                                color: AppColors.filterChipBorderActive,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast) ...[
                        const SizedBox(height: 12),
                        const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
