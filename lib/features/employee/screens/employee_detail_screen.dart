import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/employee_model.dart';

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
              _buildProfileHeader(),
              const SizedBox(height: 12),
              _buildContactInfoBox(),
              const SizedBox(height: 12),
              _buildPlacementInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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

  Widget _buildContactInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildInfoRow(AppStrings.joinDate, employee.joinDate),
          const Divider(height: 24, color: AppColors.borderLight, thickness: 1),
          _buildInfoRow(
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
                      'assets/icons/whatsapp_icon.svg',
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
          _buildInfoRow(AppStrings.email, employee.email),
        ],
      ),
    );
  }

  Widget _buildPlacementInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildInfoRow(AppStrings.location, employee.location),
          const Divider(height: 24, color: AppColors.borderLight, thickness: 1),
          _buildInfoRow(AppStrings.placement, employee.placement),
        ],
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
