import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    Color statusBgColor;
    Color statusTextColor;
    
    switch (notification.status) {
      case AppStrings.statusApproved:
        statusBgColor = AppColors.menuBgGreen;
        statusTextColor = AppColors.textSuccess;
        break;
      case AppStrings.statusRejected:
        statusBgColor = AppColors.menuBgPink;
        statusTextColor = AppColors.textDanger;
        break;
      case AppStrings.statusWaiting:
      default:
        statusBgColor = AppColors.menuBgYellow;
        statusTextColor = AppColors.textWarning;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: notification.isRead ? AppColors.bgWhite : AppColors.bgNotificationUnread,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.borderLight,
            backgroundImage: notification.avatarAsset != null
                ? AssetImage(notification.avatarAsset!)
                : null,
            child: notification.avatarAsset == null
                ? const Icon(Icons.person, color: AppColors.iconDisabled)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTextStyles.bodyMediumMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      notification.time,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.iconDisabled,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    notification.status,
                    style: AppTextStyles.bodySmallBold.copyWith(
                      color: statusTextColor,
                    ),
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
