import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/leave_allocation_provider.dart';
import '../providers/leave_provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_date_picker_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../repositories/leave_repository.dart';

class NewLeaveScreen extends ConsumerStatefulWidget {
  const NewLeaveScreen({super.key});

  @override
  ConsumerState<NewLeaveScreen> createState() => _NewLeaveScreenState();
}

class _NewLeaveScreenState extends ConsumerState<NewLeaveScreen> {
  String? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _selectedLeaveType != null &&
        _startDate != null &&
        _endDate != null &&
        _reasonController.text.trim().isNotEmpty;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy').format(date);
  }

  Future<bool> _onBeforeStartTap() async {
    if (_selectedLeaveType == null) return false;
    return true;
  }

  Future<bool> _onBeforeEndTap() async {
    if (_startDate == null) return false;
    return true;
  }

  DateTime? _getMaxEndDate() {
    if (_startDate != null && _selectedLeaveType != null) {
      final response = ref.read(leaveAllocationProvider).value;
      if (response != null) {
        final selectedAlloc = response.leaveAllocation[_selectedLeaveType];
        if (selectedAlloc != null) {
          final remaining = selectedAlloc.remainingLeaves.toInt();
          if (remaining > 0) {
            return _startDate!.add(Duration(days: remaining - 1));
          } else {
            return _startDate!;
          }
        }
      }
    }
    return DateTime(2101);
  }

  @override
  Widget build(BuildContext context) {
    final leaveAllocationsAsync = ref.watch(leaveAllocationProvider);
    final List<String> leaveTypes = leaveAllocationsAsync.when(
      data: (response) => response.leaveAllocation.keys.toList(),
      loading: () => [],
      error: (_, __) => [],
    );

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.newLeaveTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropdownField(
                      label: AppStrings.leaveTypeLabel,
                      hintText: AppStrings.selectLeaveType,
                      isRequired: true,
                      value: _selectedLeaveType,
                      items: leaveTypes,
                      onChanged: (value) {
                        setState(() {
                          _selectedLeaveType = value;
                          _endDate = null; // Reset end date when leave type changes
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDatePickerField(
                      label: AppStrings.leaveStartDate,
                      hintText: _selectedLeaveType == null 
                          ? AppStrings.errorSelectLeaveTypeFirst 
                          : AppStrings.selectStartDate,
                      isRequired: true,
                      value: _startDate,
                      firstDate: DateTime.now(),
                      onBeforeTap: _onBeforeStartTap,
                      onChanged: (date) {
                        setState(() {
                          _startDate = date;
                          _endDate = null; // Reset end date when start date changes
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDatePickerField(
                      label: AppStrings.leaveEndDate,
                      hintText: _startDate == null 
                          ? AppStrings.errorSelectStartDateFirst 
                          : AppStrings.selectEndDate,
                      isRequired: true,
                      value: _endDate,
                      firstDate: _startDate ?? DateTime.now(),
                      lastDate: _getMaxEndDate(),
                      onBeforeTap: _onBeforeEndTap,
                      onChanged: (date) {
                        setState(() {
                          _endDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: AppStrings.leaveReason,
                      hintText: AppStrings.explainLeaveReason,
                      isRequired: true,
                      maxLines: 4,
                      controller: _reasonController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: AppStrings.cancel,
                      isOutlined: true,
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: AppStrings.submit,
                      onPressed: _isFormValid() ? _showConfirmationBottomSheet : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgWhite,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.confirmLeave,
                      style: AppTextStyles.titleBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        border: Border.all(color: AppColors.menuBgGray),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildConfirmationRow(AppStrings.leaveTypeLabel, _selectedLeaveType ?? ''),
                          const Divider(color: AppColors.menuBgGray, height: 1),
                          _buildConfirmationRow(AppStrings.leaveStartDate, _formatDate(_startDate)),
                          const Divider(color: AppColors.menuBgGray, height: 1),
                          _buildConfirmationRow(AppStrings.leaveEndDate, _formatDate(_endDate)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.ensureDataCorrect,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: AppStrings.submitNow,
                          isLoading: isSubmitting,
                          onPressed: () async {
                            setModalState(() => isSubmitting = true);
                            try {
                              final repository = ref.read(leaveRepositoryProvider);
                              final leaveAllocations = ref.read(leaveAllocationProvider).value;
                              
                              final fromDate = DateFormat('yyyy-MM-dd').format(_startDate!);
                              final toDate = DateFormat('yyyy-MM-dd').format(_endDate!);
                              
                              await repository.createLeave(
                                leaveType: _selectedLeaveType!,
                                fromDate: fromDate,
                                toDate: toDate,
                                description: _reasonController.text,
                                leaveApprover: leaveAllocations?.leaveApprover ?? '',
                              );
                              
                              if (context.mounted) {
                                ref.invalidate(leaveProvider);
                                ref.invalidate(leaveAllocationProvider);
                                context.pop(); // Close bottom sheet
                                context.pushReplacement('/leave/success');
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setModalState(() => isSubmitting = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString().replaceAll('Exception: ', '')),
                                    backgroundColor: AppColors.textDanger,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
