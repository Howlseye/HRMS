import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/employee_model.dart';

class EmployeeContactInfoBox extends StatelessWidget {
  final EmployeeModel employee;
  final Widget Function(String, String, {Widget? trailingWidget}) buildInfoRow;

  const EmployeeContactInfoBox({
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
          buildInfoRow(AppStrings.joinDate, employee.joinDate),
          const Divider(height: 24, color: AppColors.borderLight, thickness: 1),
          buildInfoRow(
            AppStrings.phoneNumber,
            employee.phoneNumber ?? AppStrings.none,
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  employee.phoneNumber ?? AppStrings.none,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (employee.phoneNumber != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.whatsappIcon,
                      colorFilter: const ColorFilter.mode(
                        AppColors.iconDisabled,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 24, color: AppColors.borderLight, thickness: 1),
          buildInfoRow(AppStrings.email, employee.email),
        ],
      ),
    );
  }
}
