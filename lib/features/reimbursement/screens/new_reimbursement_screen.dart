import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../widgets/add_reimbursement_detail_bottom_sheet.dart';
import '../widgets/reimbursement_confirmation_bottom_sheet.dart';

import '../models/reimbursement_model.dart';

class NewReimbursementScreen extends StatefulWidget {
  const NewReimbursementScreen({super.key});

  @override
  State<NewReimbursementScreen> createState() => _NewReimbursementScreenState();
}

class _NewReimbursementScreenState extends State<NewReimbursementScreen> {
  final List<ReimbursementItemModel> _addedItems = [];

  Future<void> _openBottomSheet({ReimbursementItemModel? initialItem, int? index}) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReimbursementDetailBottomSheet(
        initialItem: initialItem,
        onDelete: () {
          showDialog(
            context: context,
            builder: (ctx) => AppPopup(
              svgAsset: 'assets/icons/popup_cancel_icon.svg',
              title: 'Hapus Rincian Benefit',
              description: 'Rincian ini akan dihapus dari pengajuan reimburse dan tidak dapat dipulihkan.',
              primaryButtonText: 'Hapus',
              secondaryButtonText: AppStrings.cancel,
              primaryButtonColor: AppColors.textDanger,
              onPrimaryPressed: () {
                Navigator.of(ctx).pop(); // close popup
                Navigator.of(context).pop('DELETED'); // close bottom sheet
              },
              onSecondaryPressed: () {
                Navigator.of(ctx).pop(); // close popup
              },
            ),
          );
        },
      ),
    );

    if (result == 'DELETED' && index != null) {
      setState(() {
        _addedItems.removeAt(index);
      });
      if (mounted) {
        AppSnackbar.show(
          context,
          message: 'Rincian berhasil dihapus',
          type: SnackbarType.success,
        );
      }
    } else if (result is ReimbursementItemModel) {
      setState(() {
        if (index != null) {
          _addedItems[index] = result;
        } else {
          _addedItems.add(result);
        }
      });
    }
  }
  void _showConfirmationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReimbursementConfirmationBottomSheet(
        items: _addedItems,
        onConfirm: () {
          // TODO: Implement API submit later
          context.go('/reimbursement/success');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const CustomAppBar(
        title: AppStrings.newReimburseTitle,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.bgWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.rincianBenefit,
                        style: AppTextStyles.titleBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.addBenefitSubtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_addedItems.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/empty_data.svg',
                                  width: 120,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppStrings.emptyBenefitDetail,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                OutlinedButton.icon(
                                  onPressed: _openBottomSheet,
                                  icon: const Icon(
                                    Icons.add,
                                    color: AppColors.primaryBlueStart,
                                    size: 16,
                                  ),
                                  label: Text(
                                    AppStrings.addDetail,
                                    style: AppTextStyles.bodyMediumBold.copyWith(
                                      color: AppColors.primaryBlueStart,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primaryBlueStart,
                                    side: const BorderSide(
                                      color: AppColors.primaryBlueStart,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ..._addedItems.asMap().entries.map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildDetailCard(entry.value, entry.key),
                                )),
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: _openBottomSheet,
                                  icon: const Icon(
                                    Icons.add,
                                    color: AppColors.primaryBlueStart,
                                    size: 16,
                                  ),
                                  label: Text(
                                    AppStrings.addDetail,
                                    style: AppTextStyles.bodyMediumBold.copyWith(
                                      color: AppColors.primaryBlueStart,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primaryBlueStart,
                                    side: const BorderSide(
                                      color: AppColors.primaryBlueStart,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
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
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: AppColors.bgLight,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.bgWhite,
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        AppStrings.batal,
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addedItems.isEmpty ? null : _showConfirmationSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _addedItems.isEmpty ? AppColors.buttonDisabled : AppColors.primaryBlueStart,
                        disabledBackgroundColor: AppColors.buttonDisabled,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.send,
                        style: AppTextStyles.buttonText.copyWith(
                          color: _addedItems.isEmpty ? AppColors.iconDisabled : AppColors.textWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(ReimbursementItemModel item, int index) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: AppTextStyles.bodySmallBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _openBottomSheet(initialItem: item, index: index),
                  child: const Icon(Icons.edit, color: AppColors.textSecondary, size: 16),
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
                _buildDetailRow('Tanggal Transaksi', item.transactionDate),
                const SizedBox(height: 12),
                _buildDetailRow('Jumlah yang diajukan', item.amount, isAmount: true),
                const SizedBox(height: 12),
                _buildDetailRow('Deskripsi', item.description),
                const SizedBox(height: 12),
                _buildAttachmentRow(item.attachmentName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
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

  Widget _buildAttachmentRow(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lampiran',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.open_in_new, size: 12, color: AppColors.textPrimary),
          ],
        )
      ],
    );
  }
}
