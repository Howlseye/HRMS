import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/reimbursement_model.dart';

class NewReimbursementBenefitItemCard extends StatelessWidget {
  final ReimbursementItemModel item;
  final int index;
  final VoidCallback onEdit;

  const NewReimbursementBenefitItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  onTap: onEdit,
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
                _buildDetailRow(AppStrings.tanggalTransaksi, item.transactionDate),
                const SizedBox(height: 12),
                _buildDetailRow(AppStrings.jumlahDiajukan, item.amount, isAmount: true),
                const SizedBox(height: 12),
                _buildDetailRow(AppStrings.deskripsi, item.description),
                if (item.attachmentPath != null && item.attachmentPath!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildAttachmentThumbnail(item),
                ],
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
          maxLines: label == AppStrings.deskripsi ? 1 : null,
          overflow: label == AppStrings.deskripsi ? TextOverflow.ellipsis : null,
        ),
      ],
    );
  }

  Widget _buildAttachmentThumbnail(ReimbursementItemModel item) {
    final isPdf = item.attachmentName.toLowerCase().endsWith('.pdf') || (item.attachmentPath?.toLowerCase().endsWith('.pdf') ?? false);

    if (isPdf) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.lampiran,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: AppColors.textDanger, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.attachmentName.isNotEmpty ? item.attachmentName : item.attachmentPath!.split('/').last,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.lampiran,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.file(
              File(item.attachmentPath!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Padding(
                padding: EdgeInsets.all(32.0),
                child: Icon(Icons.error, color: AppColors.textDanger),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
