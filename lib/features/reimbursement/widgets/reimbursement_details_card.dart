import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/reimbursement_model.dart';
import 'reimbursement_benefit_detail_card.dart';

class ReimbursementDetailsCard extends StatelessWidget {
  final ReimbursementModel reimbursement;

  const ReimbursementDetailsCard({
    super.key,
    required this.reimbursement,
  });

  @override
  Widget build(BuildContext context) {
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
}
