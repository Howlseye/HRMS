import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/reimbursement_model.dart';

class ReimbursementConfirmationBottomSheet extends StatelessWidget {
  final List<ReimbursementItemModel> items;
  final VoidCallback onConfirm;

  const ReimbursementConfirmationBottomSheet({
    super.key,
    required this.items,
    required this.onConfirm,
  });

  String _calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += AppCurrencyFormatter.parseToDouble(item.amount);
    }
    if (total == 0) return 'Rp0';
    return AppCurrencyFormatter.format(total);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dragHandle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Konfirmasi Reimburse',
              style: AppTextStyles.titleBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ...items.map((item) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.iconGray,
                          ),
                        ),
                        Text(
                          AppCurrencyFormatter.format(item.amount),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
                    const SizedBox(height: 12),
                  ],
                )),
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
                    'Total pengajuan',
                    style: AppTextStyles.bodyMediumBold.copyWith(
                      color: AppColors.primaryBlueStart,
                    ),
                  ),
                  Text(
                    _calculateTotal(),
                    style: AppTextStyles.bodyMediumBold.copyWith(
                      color: AppColors.primaryBlueStart,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Pastikan data yang dicantumkan sudah benar.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.iconGray,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlueStart,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Ajukan Sekarang',
                  style: AppTextStyles.buttonText.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
