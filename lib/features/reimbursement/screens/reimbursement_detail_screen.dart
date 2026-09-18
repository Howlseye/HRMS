import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/reimbursement_model.dart';

class ReimbursementDetailScreen extends StatelessWidget {
  final ReimbursementModel reimbursement;

  const ReimbursementDetailScreen({
    super.key,
    required this.reimbursement,
  });

  Color _getStatusColor() {
    switch (reimbursement.status) {
      case ReimbursementStatus.waiting:
        return AppColors.iconYellow;
      case ReimbursementStatus.approved:
        return AppColors.textSuccess;
      case ReimbursementStatus.rejected:
        return AppColors.textDanger;
    }
  }

  Color _getStatusBgColor() {
    switch (reimbursement.status) {
      case ReimbursementStatus.waiting:
        return AppColors.menuBgOrangeLight;
      case ReimbursementStatus.approved:
        return AppColors.menuBgGreen;
      case ReimbursementStatus.rejected:
        return AppColors.menuBgPink;
    }
  }

  String _getStatusText() {
    switch (reimbursement.status) {
      case ReimbursementStatus.waiting:
        return AppStrings.statusWaiting;
      case ReimbursementStatus.approved:
        return AppStrings.statusApproved;
      case ReimbursementStatus.rejected:
        return AppStrings.statusRejected;
    }
  }

  String _getStatusTitleText() {
    switch (reimbursement.status) {
      case ReimbursementStatus.waiting:
        return AppStrings.waitingApproval;
      case ReimbursementStatus.approved:
        return AppStrings.leaveApproved; 
      case ReimbursementStatus.rejected:
        return AppStrings.leaveRejected;
    }
  }

  String _getAmountLabel(ReimbursementItemModel item) {
    switch (reimbursement.status) {
      case ReimbursementStatus.approved:
        return item.approvedAmount ?? item.amount;
      case ReimbursementStatus.rejected:
        return 'Rp0';
      case ReimbursementStatus.waiting:
        return '-';
    }
  }

  String _getTotalLabel() {
    switch (reimbursement.status) {
      case ReimbursementStatus.approved:
        return _calculateTotal();
      case ReimbursementStatus.rejected:
        return 'Rp0';
      case ReimbursementStatus.waiting:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _buildStatusAlert(),
              const SizedBox(height: 12),
              _buildSummaryCard(),
              const SizedBox(height: 12),
              _buildDetailsCard(),
              if (reimbursement.status == ReimbursementStatus.waiting) ...[
                const SizedBox(height: 24),
                _buildCancelButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusAlert() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: _getStatusBgColor(),
        border: Border.all(color: _getStatusColor()),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time, 
            color: _getStatusColor(),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getStatusText(),
              style: AppTextStyles.bodySmall.copyWith(
                color: _getStatusColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
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
          const SizedBox(height: 20),
          Text(
            AppStrings.jumlahDisetujui,
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...reimbursement.items.map((item) {
            bool isPartial = reimbursement.status == ReimbursementStatus.approved && item.approvedAmount != null && item.approvedAmount != item.amount;
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

  Widget _buildDetailsCard() {
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
          ...reimbursement.items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.bgWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTextStyles.bodySmallBold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.filterChipBgActive,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItemRow(AppStrings.tanggalTransaksi, item.transactionDate),
                        const SizedBox(height: 12),
                        _buildDetailItemRow(AppStrings.jumlahDiajukan, item.amount, isAmount: true),
                        const SizedBox(height: 12),
                        _buildDetailItemRow(AppStrings.deskripsi, item.description),
                        const SizedBox(height: 12),
                        _buildAttachmentRow(item.attachmentName),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
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

  Widget _buildDetailItemRow(String label, String value, {bool isAmount = false}) {
    return Column(
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
          style: (isAmount ? AppTextStyles.bodySmallBold : AppTextStyles.bodySmall).copyWith(
            color: isAmount ? AppColors.primaryBlueStart : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentRow(String fileName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.lampiran,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.iconGray,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              fileName,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.open_in_new,
              size: 12,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
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
              onPrimaryPressed: () {
                Navigator.of(ctx).pop();
                context.go('/reimbursement/cancel-success');
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
    int total = 0;
    for (var item in reimbursement.items) {
      final amountToUse = item.approvedAmount ?? item.amount;
      final numStr = amountToUse.replaceAll(RegExp(r'[^0-9]'), '');
      if (numStr.isNotEmpty) {
        total += int.parse(numStr);
      }
    }
    if (total == 0) return '-';
    final str = total.toString();
    String formatted = '';
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formatted = '.$formatted';
      }
      formatted = str[str.length - 1 - i] + formatted;
    }
    return 'Rp$formatted';
  }
}
