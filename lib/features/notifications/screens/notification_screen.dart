import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_card.dart';
import '../../../core/widgets/app_popup.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${AppStrings.menuNotification} ',
                      style: AppTextStyles.headingExtraBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: '($unreadCount)',
                          style: AppTextStyles.headingExtraBold.copyWith(
                            color: AppColors.primaryBlueStart,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AppPopup(
                          svgAsset: 'assets/icons/popup_info_icon.svg',
                          title: AppStrings.popupMarkAllReadTitle,
                          description: AppStrings.popupMarkAllReadDesc,
                          primaryButtonText: AppStrings.popupConfirm,
                          secondaryButtonText: AppStrings.popupCancel,
                          onPrimaryPressed: () {
                            Navigator.pop(context);
                            ref.read(notificationProvider.notifier).markAllAsRead();
                          },
                          onSecondaryPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: Text(
                      '${AppStrings.markAllRead} ($unreadCount)',
                      style: AppTextStyles.bodyMediumMedium.copyWith(
                        color: AppColors.primaryBlueStart,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.borderLight),
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/empty_data.svg',
                            width: 120,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            AppStrings.noNotificationData,
                            style: AppTextStyles.titleBold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.noNotificationDataDesc,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return NotificationCard(notification: notifications[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
