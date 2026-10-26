import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickActionMenu extends StatelessWidget {
  const QuickActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(
            icon: AppAssets.absensiIcon,
            label: AppStrings.menuAbsensi,
            backgroundColor: AppColors.menuBgBlue,
            onTap: () {
              context.push('/attendance');
            },
          ),
          _buildMenuItem(
            icon: AppAssets.reimburseIcon,
            label: AppStrings.menuReimburse,
            backgroundColor: AppColors.menuBgGreen,
            onTap: () {
              context.push('/reimbursement');
            },
          ),
          _buildMenuItem(
            icon: AppAssets.cutiIcon,
            label: AppStrings.menuCuti,
            backgroundColor: AppColors.menuBgPink,
            onTap: () {
              context.push('/leave');
            },
          ),
          _buildMenuItem(
            icon: AppAssets.pengumumanIcon,
            label: AppStrings.menuPengumuman,
            backgroundColor: AppColors.menuBgYellow,
            onTap: () {
              context.push('/announcement');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String label,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16.0),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 56,
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(icon, fit: BoxFit.none, scale: 0.9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
