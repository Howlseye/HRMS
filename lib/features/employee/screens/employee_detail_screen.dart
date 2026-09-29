import 'package:flutter/material.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/employee_model.dart';
import '../widgets/employee_profile_header.dart';
import '../widgets/employee_contact_info_box.dart';
import '../widgets/employee_placement_info_box.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.detailEmployeeTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              EmployeeProfileHeader(employee: employee),
              const SizedBox(height: 12),
              EmployeeContactInfoBox(employee: employee, buildInfoRow: _buildInfoRow),
              const SizedBox(height: 12),
              EmployeePlacementInfoBox(employee: employee, buildInfoRow: _buildInfoRow),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildInfoRow(String label, String value, {Widget? trailingWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailingWidget ??
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
      ],
    );
  }
}
