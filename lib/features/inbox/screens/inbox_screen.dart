import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/inbox_provider.dart';
import '../widgets/notification_card.dart';
import '../../../core/widgets/app_popup.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(inboxProvider);
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
                      text: '${AppStrings.menuInbox} ',
                      style: AppTextStyles.headingExtraBold.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: '($unreadCount)',
                          style: AppTextStyles.headingExtraBold.copyWith(
                            color: AppColors.primaryBlueStart,
                            fontSize: 20,
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
                            ref.read(inboxProvider.notifier).markAllAsRead();
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
              child: ListView.builder(
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
