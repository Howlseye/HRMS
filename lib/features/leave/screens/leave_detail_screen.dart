import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../widgets/leave_card.dart';
import '../repositories/leave_repository.dart';
import '../providers/leave_provider.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../../../core/widgets/custom_loading_indicator.dart';

import '../models/leave_detail_args_model.dart';

class LeaveDetailScreen extends ConsumerWidget {
  final LeaveDetailArgs args;

  const LeaveDetailScreen({super.key, required this.args});

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
      appBar: CustomAppBar(
        title: AppStrings.detailLeaveTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
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
                            const Divider(
                              color: AppColors.menuBgGray,
                              height: 24,
                              thickness: 1,
                            ),
                            _buildDetailRow(
                              AppStrings.leaveSubmissionDate,
                              args.submissionDate,
                            ),
                            const Divider(
                              color: AppColors.menuBgGray,
                              height: 24,
                              thickness: 1,
                            ),
                            ref
                                .watch(currentEmployeeProvider)
                                .when(
                                  data: (employee) => Column(
                                    children: [
                                      _buildDetailRow(
                                        AppStrings.namaLengkap,
                                        employee.name,
                                      ),
                                      const Divider(
                                        color: AppColors.menuBgGray,
                                        height: 24,
                                        thickness: 1,
                                      ),
                                      _buildDetailRow(
                                        AppStrings.perusahaan,
                                        (employee.company?.isEmpty ?? true)
                                            ? '-'
                                            : employee.company!,
                                      ),
                                      const Divider(
                                        color: AppColors.menuBgGray,
                                        height: 24,
                                        thickness: 1,
                                      ),
                                      _buildDetailRow(
                                        AppStrings.departemen,
                                        employee.placement.isEmpty
                                            ? '-'
                                            : employee.placement,
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                  loading: () => const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                      child: CustomLoadingIndicator(),
                                    ),
                                  ),
                                  error: (error, stack) => const SizedBox(height: 24),
                                ),
                            Text(
                              AppStrings.detailPengajuan,
                              style: AppTextStyles.bodyMediumBold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              AppStrings.leaveType,
                              args.leaveType,
                            ),
                            const Divider(
                              color: AppColors.menuBgGray,
                              height: 24,
                              thickness: 1,
                            ),
                            _buildDetailRow(
                              AppStrings.leaveStartDate,
                              args.startDate,
                            ),
                            const Divider(
                              color: AppColors.menuBgGray,
                              height: 24,
                              thickness: 1,
                            ),
                            _buildDetailColumn(
                              AppStrings.leaveReason,
                              args.reason,
                            ),
                            if (args.status == LeaveStatus.rejected &&
                                args.rejectReason != null) ...[
                              const Divider(
                                color: AppColors.menuBgGray,
                                height: 24,
                                thickness: 1,
                              ),
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
                                    svgAsset: AppAssets.popupCancelIcon,
                                  title: AppStrings.popupCancelLeaveTitle,
                                  description: AppStrings.popupCancelLeaveDesc,
                                  primaryButtonText:
                                      AppStrings.popupCancelLeaveConfirm,
                                  secondaryButtonText: AppStrings.popupCancel,
                                  primaryButtonColor: AppColors.textDanger,
                                  onPrimaryPressed: () async {
                                    Navigator.pop(context);
                                    try {
                                      await ref
                                          .read(leaveRepositoryProvider)
                                          .cancelLeave(args.title);
                                      ref.invalidate(leaveProvider);
                                      if (context.mounted) {
                                        context.pop();
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                      AppSnackbar.show(
                                        context,
                                        message: e.toString().replaceAll('Exception: ', ''),
                                        type: SnackbarType.error,
                                      );
                                      }
                                    }
                                  },
                                  onSecondaryPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.textDanger,
                              ),
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
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.iconGray),
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
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.iconGray),
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
