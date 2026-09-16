import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../employee/models/employee_model.dart';

class HomeHeader extends StatelessWidget {
  final EmployeeModel employee;

  const HomeHeader({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.goodMorning,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                employee.name,
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (employee.avatarAsset != null && employee.avatarAsset!.isNotEmpty)
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.borderLight,
              backgroundImage: CachedNetworkImageProvider(employee.avatarAsset!),
            )
          else
            const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.borderLight,
              child: Icon(
                Icons.person,
                color: AppColors.iconDisabled,
                size: 32,
              ),
            ),
        ],
      ),
    );
  }
}
