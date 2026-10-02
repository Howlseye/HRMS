import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../providers/reimbursement_provider.dart';
import '../repositories/reimbursement_repository.dart';
import '../widgets/add_reimbursement_detail_bottom_sheet.dart';
import '../widgets/reimbursement_confirmation_bottom_sheet.dart';
import '../widgets/new_reimbursement_benefit_item_card.dart';

import '../models/reimbursement_model.dart';

class NewReimbursementScreen extends ConsumerStatefulWidget {
  const NewReimbursementScreen({super.key});

  @override
  ConsumerState<NewReimbursementScreen> createState() => _NewReimbursementScreenState();
}

class _NewReimbursementScreenState extends ConsumerState<NewReimbursementScreen> {
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
              title: AppStrings.deleteDetailConfirmTitle,
              description: AppStrings.deleteDetailConfirmDesc,
              primaryButtonText: AppStrings.confirmDelete,
              secondaryButtonText: AppStrings.batal,
              primaryButtonColor: AppColors.textDanger,
              onPrimaryPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop('DELETED');
              },
              onSecondaryPressed: () {
                Navigator.of(ctx).pop();
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
          message: AppStrings.deleteDetailSuccess,
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
      builder: (ctx) => ReimbursementConfirmationBottomSheet(
        items: _addedItems,
        onConfirm: () async {
          final employee = ref.read(currentEmployeeProvider).value;
          if (employee == null) {
            AppSnackbar.show(
              context,
              message: AppStrings.employeeDataNotLoaded,
              type: SnackbarType.error,
            );
            return;
          }

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (c) => const Center(child: CircularProgressIndicator()),
          );

          try {
            await ref.read(reimbursementRepositoryProvider).submitReimbursement(_addedItems, employee);
            if (mounted) {
              Navigator.of(context).pop();
              ref.invalidate(reimbursementProvider);
              context.go('/reimbursement/success');
            }
          } catch (e) {
            if (mounted) {
              Navigator.of(context).pop();
              AppSnackbar.show(
                context,
                message: e.toString().replaceAll('Exception: ', ''),
                type: SnackbarType.error,
              );
            }
          }
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
                      ref.watch(currentEmployeeProvider).when(
                        data: (employee) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.bgWhite,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: AppColors.borderLight)),
                                ),
                                child: Text(
                                  AppStrings.infoPengaju,
                                  style: AppTextStyles.bodySmallBold.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppStrings.namaLengkap,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
                                        ),
                                        Text(
                                          employee.name,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppStrings.perusahaan,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
                                        ),
                                        Text(
                                          (employee.company?.isEmpty ?? true) ? '-' : employee.company!,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppStrings.departemen,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
                                        ),
                                        Text(
                                          employee.placement.isEmpty ? '-' : employee.placement,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Center(child: CustomLoadingIndicator()),
                        ),
                        error: (error, stack) => const SizedBox(height: 16),
                      ),
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
                                  child: NewReimbursementBenefitItemCard(
                                    item: entry.value,
                                    index: entry.key,
                                    onEdit: () => _openBottomSheet(initialItem: entry.value, index: entry.key),
                                  ),
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
}
