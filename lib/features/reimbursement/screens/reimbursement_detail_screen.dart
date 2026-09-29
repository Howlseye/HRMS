import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/reimbursement_model.dart';
import '../widgets/reimbursement_summary_card.dart';
import '../widgets/reimbursement_details_card.dart';
import '../widgets/reimbursement_cancel_button.dart';

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
              ReimbursementSummaryCard(
                reimbursement: reimbursement,
                statusTitle: _getStatusTitleText(),
                totalLabel: _getTotalLabel(),
                getAmountLabel: _getAmountLabel,
              ),
              const SizedBox(height: 12),
              ReimbursementDetailsCard(reimbursement: reimbursement),
            ],
          ),
        ),
      ),
      bottomNavigationBar: reimbursement.status == ReimbursementStatus.draft
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReimbursementCancelButton(reimbursement: reimbursement),
              ),
            )
          : null,
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
