import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/employee_model.dart';

class EmployeeProfileHeader extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeProfileHeader({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.borderLight,
            backgroundImage: employee.avatarAsset != null
                ? AssetImage(employee.avatarAsset!)
                : null,
            child: employee.avatarAsset == null
                ? const Icon(Icons.person, color: AppColors.iconDisabled, size: 40)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            employee.name,
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            employee.role,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
