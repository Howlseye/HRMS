import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickActionMenu extends StatelessWidget {
  const QuickActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(
            icon: 'assets/icons/absensi_icon.png',
            label: AppStrings.menuAbsensi,
            backgroundColor: AppColors.menuBgBlue,
            onTap: () {},
          ),
          const SizedBox(width: 24),
          _buildMenuItem(
            icon: 'assets/icons/reimburse_icon.png',
            label: AppStrings.menuReimburse,
            backgroundColor: AppColors.menuBgGreen,
            onTap: () {},
          ),
          const SizedBox(width: 24),
          _buildMenuItem(
            icon: 'assets/icons/lembur_icon.png',
            label: AppStrings.menuLembur,
            backgroundColor: AppColors.menuBgYellow,
            onTap: () {},
          ),
          const SizedBox(width: 24),
          _buildMenuItem(
            icon: 'assets/icons/cuti_icon.png',
            label: AppStrings.menuCuti,
            backgroundColor: AppColors.menuBgPink,
            onTap: () {},
          ),
          const SizedBox(width: 24),
          _buildMenuItem(
            icon: 'assets/icons/slip_gaji_icon.png',
            label: AppStrings.menuSlipGaji,
            backgroundColor: AppColors.menuBgLavender,
            onTap: () {},
          ),
          const SizedBox(width: 24),
          _buildMenuItem(
            icon: 'assets/icons/log_book_icon.png',
            label: AppStrings.menuLogBook,
            backgroundColor: AppColors.menuBgPeach,
            onTap: () {},
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
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(icon, fit: BoxFit.none, scale: 0.9,),
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
