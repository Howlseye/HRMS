import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/announcement_model.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const CustomAppBar(
        title: AppStrings.detailPengumuman,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 380,
                decoration: BoxDecoration(
                  color: AppColors.iconDisabled.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    color: AppColors.textSecondary,
                    size: 64,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                announcement.date,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.iconDisabled,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 4),
              Text(
                announcement.title,
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                announcement.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
