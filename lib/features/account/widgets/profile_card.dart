import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../employee/models/employee_model.dart';

class ProfileCard extends StatelessWidget {
  final EmployeeModel employee;

  const ProfileCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          if (employee.avatarAsset != null && employee.avatarAsset!.isNotEmpty)
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.borderLight,
              backgroundImage: CachedNetworkImageProvider(employee.avatarAsset!),
            )
          else
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.borderLight,
              child: Icon(
                Icons.person,
                size: 32,
                color: AppColors.iconDisabled,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.role,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.iconDisabled,
          ),
        ],
      ),
    );
  }
}
