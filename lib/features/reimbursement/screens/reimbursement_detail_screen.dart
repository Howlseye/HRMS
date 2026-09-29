import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../models/reimbursement_model.dart';
import '../repositories/reimbursement_repository.dart';
import '../providers/reimbursement_provider.dart';
import '../widgets/reimbursement_benefit_detail_card.dart';

class ReimbursementDetailScreen extends ConsumerWidget {
  final ReimbursementModel reimbursement;

  const ReimbursementDetailScreen({
    super.key,
    required this.reimbursement,
  });


  String _getStatusTitleText() {
    switch (reimbursement.status) {
      case ReimbursementStatus.draft:
      case ReimbursementStatus.unpaid:
        return AppStrings.waitingApproval;
      case ReimbursementStatus.submitted:
      case ReimbursementStatus.paid:
        return AppStrings.leaveApproved; 
      case ReimbursementStatus.rejected:
      case ReimbursementStatus.cancelled:
        return AppStrings.leaveRejected;
    }
  }

  String _getAmountLabel(ReimbursementItemModel item) {
    switch (reimbursement.status) {
      case ReimbursementStatus.submitted:
      case ReimbursementStatus.paid:
        return AppCurrencyFormatter.format(item.approvedAmount ?? item.amount);
      case ReimbursementStatus.rejected:
      case ReimbursementStatus.cancelled:
        return '${AppStrings.rpText}0';
      case ReimbursementStatus.draft:
      case ReimbursementStatus.unpaid:
        return AppStrings.none;
    }
  }

  String _getTotalLabel() {
    switch (reimbursement.status) {
      case ReimbursementStatus.submitted:
      case ReimbursementStatus.paid:
        return _calculateTotal();
      case ReimbursementStatus.rejected:
      case ReimbursementStatus.cancelled:
        return '${AppStrings.rpText}0';
      case ReimbursementStatus.draft:
      case ReimbursementStatus.unpaid:
        return AppStrings.none;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const CustomAppBar(
        title: AppStrings.detailReimbursementTitle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryCard(context, ref),
              const SizedBox(height: 12),
              _buildDetailsCard(context, ref),
            ],
          ),
        ),
      ),
      bottomNavigationBar: reimbursement.status == ReimbursementStatus.draft
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildCancelButton(context, ref),
              ),
            )
          : null,
    );
  }


  Widget _buildSummaryCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getStatusTitleText(),
            style: AppTextStyles.titleBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _buildRow(AppStrings.idPengajuan, reimbursement.id),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
          const SizedBox(height: 12),
          _buildRow(AppStrings.tanggalPengajuan, reimbursement.date),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
          const SizedBox(height: 12),
          ref.watch(currentEmployeeProvider).when(
            data: (employee) => Column(
              children: [
                _buildRow(AppStrings.namaLengkap, employee.name),
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
                const SizedBox(height: 12),
                _buildRow(AppStrings.perusahaan, (employee.company?.isEmpty ?? true) ? '-' : employee.company!),
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
                const SizedBox(height: 12),
                _buildRow(AppStrings.departemen, employee.placement.isEmpty ? '-' : employee.placement),
                const SizedBox(height: 20),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => const SizedBox(height: 20),
          ),
          Text(
            AppStrings.jumlahDisetujui,
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...reimbursement.items.map((item) {
            bool isPartial = reimbursement.status == ReimbursementStatus.submitted && item.approvedAmount != null && item.approvedAmount != item.amount;
            return Column(
              children: [
                _buildRow(
                  item.name,
                  _getAmountLabel(item),
                  valueColor: isPartial ? AppColors.iconOrange : AppColors.textPrimary,
                ),
                if (isPartial && item.notes != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.menuBgGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppStrings.notesPrefix,
                            style: AppTextStyles.bodyMediumBold.copyWith(
                              color: AppColors.iconGray,
                            ),
                          ),
                          TextSpan(
                            text: item.notes!.replaceFirst(AppStrings.notesPrefix, ''),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.iconGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
                const SizedBox(height: 12),
              ],
            );
          }),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.menuBgBlue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.totalDisetujui,
                  style: AppTextStyles.bodyMediumBold.copyWith(
                    color: AppColors.primaryBlueStart,
                  ),
                ),
                Text(
                  _getTotalLabel(),
                  style: AppTextStyles.bodyMediumBold.copyWith(
                    color: AppColors.primaryBlueStart,
                  ),
                ),
              ],
            ),
          ),
          if (reimbursement.status == ReimbursementStatus.rejected && reimbursement.rejectReason != null) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
            const SizedBox(height: 16),
            Text(
              AppStrings.leaveRejectReason,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.iconGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reimbursement.rejectReason!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDanger,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.rincianBenefit,
            style: AppTextStyles.titleBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: reimbursement.items.map((item) {
              return ReimbursementBenefitDetailCard(item: item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.iconGray,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }


  Widget _buildCancelButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AppPopup(
              svgAsset: 'assets/icons/popup_cancel_icon.svg',
              title: AppStrings.cancelReimburseTitle,
              description: AppStrings.cancelReimburseDesc,
              primaryButtonText: AppStrings.confirmCancel,
              secondaryButtonText: AppStrings.cancel,
              primaryButtonColor: AppColors.textDanger,
              onPrimaryPressed: () async {
                Navigator.of(ctx).pop();

                try {
                  await ref.read(reimbursementRepositoryProvider).cancelReimbursement(reimbursement.id);
                  if (context.mounted) {
                    ref.invalidate(reimbursementProvider);
                    context.go('/reimbursement/cancel-success');
                  }
                } catch (e) {
                  if (context.mounted) {
                    AppSnackbar.show(
                      context,
                      message: e.toString(),
                      type: SnackbarType.error,
                    );
                  }
                }
              },
              onSecondaryPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.bgWhite,
          side: const BorderSide(color: AppColors.textDanger),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          AppStrings.cancelLeave,
          style: AppTextStyles.buttonText.copyWith(
            color: AppColors.textDanger,
          ),
        ),
      ),
    );
  }

  String _calculateTotal() {
    double total = 0;
    for (var item in reimbursement.items) {
      final amountToUse = item.approvedAmount ?? item.amount;
      final cleanStr = amountToUse.replaceAll(RegExp(r'[^0-9.]'), '');
      if (cleanStr.isNotEmpty) {
        total += double.tryParse(cleanStr) ?? 0;
      }
    }
    if (total == 0) return AppStrings.none;
    return AppCurrencyFormatter.format(total);
  }
}
