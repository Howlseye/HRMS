import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class AddLogBookScreen extends ConsumerStatefulWidget {
  const AddLogBookScreen({super.key});

  @override
  ConsumerState<AddLogBookScreen> createState() => _AddLogBookScreenState();
}

class _AddLogBookScreenState extends ConsumerState<AddLogBookScreen> {
  final List<String> _selectedActivities = [];
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _constraintController = TextEditingController();

  bool get _isFormValid => 
    _selectedActivities.isNotEmpty && _summaryController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _summaryController.addListener(() {
      setState(() {});
    });
  }

  String get _currentDate {
    final now = DateTime.now();
    final monthName = AppStrings.monthNames[now.month - 1];
    return '${now.day} $monthName ${now.year}';
  }

  final List<String> _activities = [
    AppStrings.addLogBookActivityOptionsDevelopment,
    AppStrings.addLogBookActivityOptionsBugFixing,
    AppStrings.addLogBookActivityOptionsTesting,
    AppStrings.addLogBookActivityOptionsMeeting,
    AppStrings.addLogBookActivityOptionsDocumentation,
    AppStrings.addLogBookActivityOptionsSupport,
    AppStrings.addLogBookActivityOptionsOther,
  ];

  @override
  void dispose() {
    _summaryController.dispose();
    _constraintController.dispose();
    super.dispose();
  }

  Widget _buildCheckboxItem(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_selectedActivities.contains(label)) {
              _selectedActivities.remove(label);
            } else {
              _selectedActivities.add(label);
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
                  value: _selectedActivities.contains(label),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedActivities.add(label);
                      } else {
                        _selectedActivities.remove(label);
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
        title: AppStrings.addLogBookTitle,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppColors.menuBgBlue,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _currentDate,
                              style: AppTextStyles.titleBold.copyWith(
                                color: AppColors.primaryBlueStart,
                              ),
                            ),
                            const Icon(
                              Icons.date_range,
                              color: AppColors.primaryBlueStart,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      RichText(
                        text: TextSpan(
                          text: AppStrings.addLogBookActivityQuestion,
                          style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textPrimary),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textDanger),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      ..._activities.map((activity) => _buildCheckboxItem(activity)),
                      
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: AppStrings.addLogBookSummaryLabel,
                        hintText: AppStrings.addLogBookSummaryHint,
                        controller: _summaryController,
                        isRequired: true,
                        maxLines: 4,
                      ),
                      
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: AppStrings.addLogBookConstraintLabel,
                        hintText: AppStrings.addLogBookConstraintHint,
                        controller: _constraintController,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
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
                      text: AppStrings.btnSubmit,
                      onPressed: _isFormValid ? () {
                        context.push('/add-log-book-success', extra: {
                          'activities': _selectedActivities,
                          'summary': _summaryController.text,
                          'constraint': _constraintController.text,
                        });
                      } : null,
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
