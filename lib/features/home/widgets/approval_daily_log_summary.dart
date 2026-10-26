import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class ApprovalDailyLogSummary extends StatelessWidget {
  final int waitingCount;
  final int totalParticipants;
  final int notSubmitCount;
  final VoidCallback? onReviewTap;

  const ApprovalDailyLogSummary({
    super.key,
    required this.waitingCount,
    required this.totalParticipants,
    required this.notSubmitCount,
    this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        GestureDetector(
          onTap: onReviewTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.menuBgBlue,
              border: Border.all(color: AppColors.borderBlueLight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.book,
                  color: AppColors.primaryBlueStart,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppStrings.reviewToday,
                            style: AppTextStyles.bodyMediumMedium.copyWith(
                              color: AppColors.iconNavy,
                            ),
                          ),
                          if (waitingCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.textDanger,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                waitingCount > 9 ? AppStrings.ninePlus : waitingCount.toString(),
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '$waitingCount ${AppStrings.participantsNeedApproval}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.iconNavy,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.iconNavy,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(child: _buildStatCard(
              title: AppStrings.totalParticipants,
              value: totalParticipants.toString(),
              icon: Icons.people,
              iconColor: AppColors.primaryBlueStart,
              iconBgColor: AppColors.menuBgBlue,
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(
              title: AppStrings.waitingApprove,
              value: waitingCount.toString(),
              icon: Icons.hourglass_empty,
              iconColor: AppColors.iconYellow,
              iconBgColor: AppColors.menuBgOrangeLight,
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(
              title: AppStrings.notSubmit,
              value: notSubmitCount.toString(),
              icon: Icons.cancel_presentation,
              iconColor: AppColors.iconDisabled,
              iconBgColor: AppColors.menuBgGray,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.label.copyWith(
              color: AppColors.iconGray,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
