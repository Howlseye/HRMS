import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/task_item_model.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final TaskItem? initialTask;

  const AddTaskScreen({
    super.key,
    this.initialTask,
  });

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final List<String> _selectedTaskTypes = [];
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _constraintController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  final List<String> _taskTypes = [
    AppStrings.addLogBookActivityOptionsDevelopment,
    AppStrings.addLogBookActivityOptionsBugFixing,
    AppStrings.addLogBookActivityOptionsTesting,
    AppStrings.addLogBookActivityOptionsMeeting,
    AppStrings.addLogBookActivityOptionsDocumentation,
    AppStrings.addLogBookActivityOptionsSupport,
    AppStrings.addLogBookActivityOptionsOther,
  ];

  bool get _isFormValid =>
      _selectedTaskTypes.isNotEmpty &&
      _summaryController.text.trim().isNotEmpty &&
      (_hoursController.text.trim().isNotEmpty || _minutesController.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      _selectedTaskTypes.addAll(widget.initialTask!.types);
      _summaryController.text = widget.initialTask!.summary;
      _constraintController.text = widget.initialTask!.constraints;
      if (widget.initialTask!.hours > 0) {
        _hoursController.text = widget.initialTask!.hours.toString();
      }
      if (widget.initialTask!.minutes > 0) {
        _minutesController.text = widget.initialTask!.minutes.toString();
      }
    }
    _summaryController.addListener(_updateState);
    _hoursController.addListener(_updateState);
    _minutesController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _constraintController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationPopup() {
    showDialog(
      context: context,
      builder: (dialogContext) => AppPopup(
        svgAsset: AppAssets.popupCancelIcon,
        iconColor: AppColors.textDanger,
        title: AppStrings.deleteTaskPopupTitle,
        description: AppStrings.deleteTaskPopupDesc,
        primaryButtonText: AppStrings.confirmDelete,
        secondaryButtonText: AppStrings.batal,
        primaryButtonColor: AppColors.textDanger,
        onPrimaryPressed: () {
          Navigator.of(dialogContext).pop();
          context.pop('DELETE');
        },
        onSecondaryPressed: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  Widget _buildCheckboxItem(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_selectedTaskTypes.contains(label)) {
              _selectedTaskTypes.remove(label);
            } else {
              _selectedTaskTypes.add(label);
            }
          });
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _selectedTaskTypes.contains(label),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedTaskTypes.add(label);
                      } else {
                        _selectedTaskTypes.remove(label);
                      }
                    });
                  },
                  activeColor: AppColors.primaryBlueStart,
                  checkColor: AppColors.textWhite,
                  side: const BorderSide(color: AppColors.iconDisabled),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: widget.initialTask != null ? AppStrings.editTaskTitle : AppStrings.addTaskBtn,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textDark,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.bgWhite,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: AppStrings.taskTypeLabel,
                          style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textPrimary),
                          children: [
                            TextSpan(
                              text: AppStrings.requiredAsterisk,
                              style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textDanger),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._taskTypes.map((type) => _buildCheckboxItem(type)),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: AppStrings.taskSummaryLabel,
                        hintText: AppStrings.taskSummaryHint,
                        controller: _summaryController,
                        isRequired: true,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: AppStrings.constraints,
                        hintText: AppStrings.taskConstraintHint,
                        controller: _constraintController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          text: AppStrings.durationLabel,
                          style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textPrimary),
                          children: [
                            TextSpan(
                              text: AppStrings.requiredAsterisk,
                              style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textDanger),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _hoursController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppStrings.zeroText,
                                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.iconDisabled),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    AppStrings.hoursLabel,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: AppColors.borderLight),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: AppColors.borderLight),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: AppColors.primaryBlueStart),
                                ),
                                filled: true,
                                fillColor: AppColors.bgWhite,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _minutesController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppStrings.zeroText,
                                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.iconDisabled),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    AppStrings.minutesLabel,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: AppColors.borderLight),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: AppColors.borderLight),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(color: AppColors.primaryBlueStart),
                                ),
                                filled: true,
                                fillColor: AppColors.bgWhite,
                              ),
                            ),
                          ),
                        ],
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: widget.initialTask != null
                        ? OutlinedButton(
                            onPressed: _showDeleteConfirmationPopup,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.textDanger),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              AppStrings.confirmDelete,
                              style: AppTextStyles.title.copyWith(
                                color: AppColors.textDanger,
                              ),
                            ),
                          )
                        : CustomButton(
                            text: AppStrings.batal,
                            isOutlined: true,
                            onPressed: () {
                              context.pop();
                            },
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: AppStrings.btnSave,
                      onPressed: _isFormValid
                          ? () {
                              final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
                              final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;
                              final taskItem = TaskItem(
                                types: List.from(_selectedTaskTypes),
                                summary: _summaryController.text.trim(),
                                constraints: _constraintController.text.trim(),
                                hours: hours,
                                minutes: minutes,
                              );
                              context.pop(taskItem);
                            }
                          : null,
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
