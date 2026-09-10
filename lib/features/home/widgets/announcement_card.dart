import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.iconDisabled.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(
              child: Icon(Icons.image, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.iconDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
