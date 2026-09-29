import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../models/employee_model.dart';

class EmployeePlacementInfoBox extends StatelessWidget {
  final EmployeeModel employee;
  final Widget Function(String, String, {Widget? trailingWidget}) buildInfoRow;

  const EmployeePlacementInfoBox({
    super.key,
    required this.employee,
    required this.buildInfoRow,
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
          buildInfoRow(AppStrings.location, employee.location),
          const Divider(height: 24, color: AppColors.borderLight, thickness: 1),
          buildInfoRow(AppStrings.placement, employee.placement),
        ],
      ),
    );
  }
}
