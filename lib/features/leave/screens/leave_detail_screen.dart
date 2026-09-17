import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../widgets/leave_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/leave_repository.dart';
import '../providers/leave_provider.dart';

class LeaveDetailArgs {
  final String title;
  final LeaveStatus status;
  final String submissionDate;
  final String leaveType;
  final String startDate;
  final String reason;
  final String? rejectReason;

  LeaveDetailArgs({
    required this.title,
    required this.status,
    required this.submissionDate,
    required this.leaveType,
    required this.startDate,
    required this.reason,
    this.rejectReason,
  });
}

class LeaveDetailScreen extends ConsumerWidget {
  final LeaveDetailArgs args;

  const LeaveDetailScreen({super.key, required this.args});

  String _getStatusAlertText() {
    switch (args.status) {
      case LeaveStatus.waiting:
        return AppStrings.statusWaiting;
      case LeaveStatus.approved:
        return AppStrings.statusApproved;
      case LeaveStatus.rejected:
        return AppStrings.statusRejected;
      case LeaveStatus.cancelled:
        return AppStrings.statusCancelled;
    }
  }

  Color _getStatusColor() {
    switch (args.status) {
      case LeaveStatus.waiting:
        return AppColors.iconYellow;
      case LeaveStatus.approved:
        return AppColors.textSuccess;
      case LeaveStatus.rejected:
      case LeaveStatus.cancelled:
        return AppColors.textDanger;
    }
  }

  Color _getStatusBgColor() {
    switch (args.status) {
      case LeaveStatus.waiting:
        return AppColors.menuBgOrangeLight;
      case LeaveStatus.approved:
        return AppColors.menuBgGreen;
      case LeaveStatus.rejected:
      case LeaveStatus.cancelled:
        return AppColors.menuBgPink;
    }
  }

  IconData _getStatusIcon() {
    switch (args.status) {
      case LeaveStatus.waiting:
        return Icons.access_time_filled;
      case LeaveStatus.approved:
        return Icons.check_circle_outline;
      case LeaveStatus.rejected:
      case LeaveStatus.cancelled:
        return Icons.error_outline;
    }
  }

  String _getStatusTitle() {
    switch (args.status) {
      case LeaveStatus.waiting:
        return AppStrings.waitingApproval;
      case LeaveStatus.approved:
        return AppStrings.leaveApproved;
      case LeaveStatus.rejected:
        return AppStrings.leaveRejected;
      case LeaveStatus.cancelled:
        return AppStrings.leaveCancelled;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconNavy),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.detailLeaveTitle,
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomRefreshIndicator(
          onRefresh: () => ref.refresh(leaveProvider.future),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
              decoration: BoxDecoration(
                color: _getStatusBgColor(),
                border: Border.all(color: _getStatusColor().withAlpha(127)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(),
                    size: 16,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    _getStatusAlertText(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _getStatusColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(),
                    style: AppTextStyles.titleBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(AppStrings.leaveId, args.title),
                  const Divider(color: AppColors.menuBgGray, height: 24, thickness: 1),
                  _buildDetailRow(AppStrings.leaveSubmissionDate, args.submissionDate),
                  const Divider(color: AppColors.menuBgGray, height: 24, thickness: 1),
                  _buildDetailRow(AppStrings.leaveType, args.leaveType),
                  const Divider(color: AppColors.menuBgGray, height: 24, thickness: 1),
                  _buildDetailRow(AppStrings.leaveStartDate, args.startDate),
                  const Divider(color: AppColors.menuBgGray, height: 24, thickness: 1),
                  _buildDetailColumn(AppStrings.leaveReason, args.reason),
                  if (args.status == LeaveStatus.rejected && args.rejectReason != null) ...[
                    const Divider(color: AppColors.menuBgGray, height: 24, thickness: 1),
                    _buildDetailColumn(
                      AppStrings.leaveRejectReason,
                      args.rejectReason!,
                      valueColor: AppColors.textDanger,
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            if (args.status == LeaveStatus.waiting)
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppPopup(
                        svgAsset: 'assets/icons/popup_cancel_icon.svg',
                        title: AppStrings.popupCancelLeaveTitle,
                        description: AppStrings.popupCancelLeaveDesc,
                        primaryButtonText: AppStrings.popupCancelLeaveConfirm,
                        secondaryButtonText: AppStrings.popupCancel,
                        primaryButtonColor: AppColors.textDanger,
                        onPrimaryPressed: () async {
                          Navigator.pop(context); // close popup
                          try {
                            await ref.read(leaveRepositoryProvider).cancelLeave(args.title);
                            ref.invalidate(leaveProvider);
                            if (context.mounted) {
                              context.pop(); // close detail screen
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        onSecondaryPressed: () {
                          Navigator.pop(context); // close popup
                        },
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textDanger),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    AppStrings.cancelLeave,
                    style: AppTextStyles.titleSemiBold.copyWith(
                      color: AppColors.textDanger,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ],
      ),
      ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 152,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.iconGray,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailColumn(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.iconGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
