import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class EmptyDataWidget extends StatelessWidget {
  final String title;
  final String description;
  final double iconWidth;

  const EmptyDataWidget({
    super.key,
    required this.title,
    required this.description,
    this.iconWidth = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/empty_data.svg',
            width: iconWidth,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTextStyles.titleBold.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
