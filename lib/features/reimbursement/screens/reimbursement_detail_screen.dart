import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/shared_prefs_provider.dart';
import '../../auth/providers/auth_session_provider.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../models/reimbursement_model.dart';
import '../repositories/reimbursement_repository.dart';
import '../providers/reimbursement_provider.dart';

class ReimbursementDetailScreen extends ConsumerWidget {
  final ReimbursementModel reimbursement;

  const ReimbursementDetailScreen({
    super.key,
    required this.reimbursement,
  });


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
        return AppCurrencyFormatter.format(item.approvedAmount ?? item.amount);
      case ReimbursementStatus.rejected:
        return '${AppStrings.rpText}0';
      case ReimbursementStatus.waiting:
        return AppStrings.none;
    }
  }

  String _getTotalLabel() {
    switch (reimbursement.status) {
      case ReimbursementStatus.approved:
        return _calculateTotal();
      case ReimbursementStatus.rejected:
        return '${AppStrings.rpText}0';
      case ReimbursementStatus.waiting:
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
      bottomNavigationBar: reimbursement.status == ReimbursementStatus.waiting
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
                        _buildDetailItemRow(AppStrings.jumlahDiajukan, AppCurrencyFormatter.format(item.amount), isAmount: true),
                        const SizedBox(height: 12),
                        _buildDetailItemRow(AppStrings.deskripsi, item.description.isEmpty ? AppStrings.none : item.description),
                        const SizedBox(height: 12),
                        _buildAttachmentRow(context, ref, item),
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

  Widget _buildAttachmentRow(BuildContext context, WidgetRef ref, ReimbursementItemModel item) {
    if (item.attachmentPath == null || item.attachmentPath!.isEmpty) {
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
          Text(
            AppStrings.none,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );
    }

    final prefs = ref.read(sharedPreferencesProvider);
    final session = ref.read(authSessionProvider);
    final sid = session['sid'] ?? prefs.getString('sid');
    final cookie = (sid != null && sid.isNotEmpty) ? 'sid=$sid' : null;

    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final imageUrl = '$baseUrl${item.attachmentPath}';
    final isPdf = item.attachmentName.toLowerCase().endsWith('.pdf') || (item.attachmentPath?.toLowerCase().endsWith('.pdf') ?? false);

    if (isPdf) {
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
          GestureDetector(
            onTap: () {
              if (item.attachmentName.isNotEmpty && item.attachmentPath != null) {
                final prefs = ref.read(sharedPreferencesProvider);
                final session = ref.read(authSessionProvider);
                final sid = session['sid'] ?? prefs.getString('sid');
                final cookie = (sid != null && sid.isNotEmpty) ? 'sid=$sid' : null;
                final baseUrl = dotenv.env['BASE_URL'] ?? '';
                final imageUrl = '$baseUrl${item.attachmentPath}';
                _showAttachmentPopup(context, ref, item, imageUrl, isPdf: true, cookie: cookie);
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.attachmentName.split('/').last,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.lampiran,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.iconGray,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _showAttachmentPopup(context, ref, item, imageUrl, isPdf: isPdf, cookie: cookie);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
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
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Icon(Icons.error, color: AppColors.textDanger),
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAttachmentPopup(BuildContext context, WidgetRef ref, ReimbursementItemModel item, String imageUrl, {bool isPdf = false, String? cookie}) {
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
                        item.attachmentName.split('/').last,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
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
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
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
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.textDanger),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
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
                            message: '${AppStrings.downloadFailed}: $e',
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
                        borderRadius: BorderRadius.circular(6),
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
