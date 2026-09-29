import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../models/reimbursement_model.dart';

class ReimbursementSummaryCard extends ConsumerWidget {
  final ReimbursementModel reimbursement;
  final String statusTitle;
  final String totalLabel;
  final String Function(ReimbursementItemModel) getAmountLabel;

  const ReimbursementSummaryCard({
    super.key,
    required this.reimbursement,
    required this.statusTitle,
    required this.totalLabel,
    required this.getAmountLabel,
  });

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
          style: AppTextStyles.bodyMediumBold.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            statusTitle,
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
                  getAmountLabel(item),
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
              color: AppColors.filterChipBgActive,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.totalDisetujui,
                  style: AppTextStyles.bodyMediumBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  totalLabel,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.primaryBlueStart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
