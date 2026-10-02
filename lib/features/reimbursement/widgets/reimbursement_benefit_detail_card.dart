import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/shared_prefs_provider.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../auth/providers/auth_session_provider.dart';
import '../models/reimbursement_model.dart';
import '../repositories/reimbursement_repository.dart';

class ReimbursementBenefitDetailCard extends ConsumerWidget {
  final ReimbursementItemModel item;

  const ReimbursementBenefitDetailCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showItemDetailPopup(context, ref, item),
      child: Container(
        width: (MediaQuery.of(context).size.width - 70) / 2,
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
                  _buildAttachmentRow(context, ref, item),
                  const SizedBox(height: 12),
                  _buildDetailItemRow(AppStrings.tanggalTransaksi, item.transactionDate),
                  const SizedBox(height: 12),
                  _buildDetailItemRow(AppStrings.jumlahDiajukan, AppCurrencyFormatter.format(item.amount), isAmount: true),
                  const SizedBox(height: 12),
                  _buildDetailItemRow(AppStrings.deskripsi, item.description.isEmpty ? AppStrings.none : item.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItemRow(String label, String value, {bool isAmount = false, bool forceFullText = false}) {
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
          maxLines: (label == AppStrings.deskripsi && !forceFullText) ? 1 : null,
          overflow: (label == AppStrings.deskripsi && !forceFullText) ? TextOverflow.ellipsis : null,
        ),
      ],
    );
  }

  Widget _buildAttachmentRow(BuildContext context, WidgetRef ref, ReimbursementItemModel item) {
    if (item.attachmentPath == null || item.attachmentPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    final prefs = ref.read(sharedPreferencesProvider);
    final session = ref.read(authSessionProvider);
    final sid = session['sid'] ?? prefs.getString('sid');
    final cookie = (sid != null && sid.isNotEmpty) ? 'sid=$sid' : null;

    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final imageUrl = '$baseUrl${item.attachmentPath}';
    final isPdf = item.attachmentName.toLowerCase().endsWith('.pdf') || (item.attachmentPath?.toLowerCase().endsWith('.pdf') ?? false);

    if (isPdf) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(
              Icons.picture_as_pdf,
              size: 40,
              color: AppColors.textDanger,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          httpHeaders: cookie != null ? {'Cookie': cookie} : null,
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CustomLoadingIndicator()),
          ),
          errorWidget: (context, url, error) => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Icon(Icons.error, color: AppColors.textDanger),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showItemDetailPopup(BuildContext context, WidgetRef ref, ReimbursementItemModel item) {
    final prefs = ref.read(sharedPreferencesProvider);
    final session = ref.read(authSessionProvider);
    final sid = session['sid'] ?? prefs.getString('sid');
    final cookie = (sid != null && sid.isNotEmpty) ? 'sid=$sid' : null;
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    
    final bool hasAttachment = item.attachmentPath != null && item.attachmentPath!.isNotEmpty;
    final String imageUrl = hasAttachment ? '$baseUrl${item.attachmentPath}' : '';
    final bool isPdf = hasAttachment && (item.attachmentName.toLowerCase().endsWith('.pdf') || (item.attachmentPath?.toLowerCase().endsWith('.pdf') ?? false));

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.bgWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: AppTextStyles.bodyMediumBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.borderLight, height: 1, thickness: 1),
              
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasAttachment) ...[
                        GestureDetector(
                          onTap: isPdf ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  backgroundColor: AppColors.textDark,
                                  appBar: AppBar(
                                    backgroundColor: AppColors.textDark,
                                    iconTheme: const IconThemeData(color: AppColors.textWhite),
                                  ),
                                  body: Center(
                                    child: InteractiveViewer(
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        httpHeaders: cookie != null ? {'Cookie': cookie} : null,
                                        placeholder: (context, url) => const Center(child: CustomLoadingIndicator()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.textDanger),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: double.infinity,
                              height: 250,
                              child: isPdf 
                                  ? const Icon(
                                      Icons.picture_as_pdf,
                                      size: 100,
                                      color: AppColors.textDanger,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      httpHeaders: cookie != null ? {'Cookie': cookie} : null,
                                      placeholder: (context, url) => const Center(child: CustomLoadingIndicator()),
                                      errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.textDanger),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      _buildDetailItemRow(AppStrings.tanggalTransaksi, item.transactionDate, forceFullText: true),
                      const SizedBox(height: 12),
                      _buildDetailItemRow(AppStrings.jumlahDiajukan, AppCurrencyFormatter.format(item.amount), isAmount: true, forceFullText: true),
                      const SizedBox(height: 12),
                      _buildDetailItemRow(AppStrings.deskripsi, item.description.isEmpty ? AppStrings.none : item.description, forceFullText: true),
                    ],
                  ),
                ),
              ),

              if (hasAttachment)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        try {
                          final savePath = await ref.read(reimbursementRepositoryProvider).downloadAttachment(
                            imageUrl,
                            item.attachmentName.split('/').last,
                          );
                          
                          if (context.mounted) {
                            AppSnackbar.show(
                              context,
                              message: '${AppStrings.downloadSuccess}: $savePath',
                              type: SnackbarType.success,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            AppSnackbar.show(
                              context,
                              message: '${AppStrings.downloadFailed}: ${e.toString().replaceAll('Exception: ', '')}',
                              type: SnackbarType.error,
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.download, color: AppColors.textWhite),
                      label: Text(
                        AppStrings.downloadText,
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.textWhite,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlueStart,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
