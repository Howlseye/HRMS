import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/home_provider.dart';
import '../widgets/home_header.dart';
import '../../../core/widgets/attendance_card.dart';
import '../widgets/quick_action_menu.dart';
import '../../../core/widgets/attendance_activity_card.dart';
import '../widgets/announcement_card.dart';
import '../../attendance/models/attendance_log_entry.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityProvider);
    final announcements = ref.watch(announcementProvider);
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const AttendanceCard(),
              const QuickActionMenu(),
              _buildSectionHeader(
                title: AppStrings.todaysActivity,
                onTap: () {
                  context.push('/attendance-log');
                },
              ),
              ...activities.map((activity) => AttendanceActivityCard(
                    icon: activity.icon,
                    title: activity.title,
                    date: activity.date,
                    time: activity.time,
                    iconColor: activity.iconColor,
                    iconBgColor: activity.iconBgColor,
                    isTimeWarning: activity.isTimeWarning,
                    onTap: () {
                      final dummyEntry = AttendanceLogEntry(
                        id: 'dummy',
                        date: activity.date,
                        fullDate: 'Sel, ${activity.date}',
                        workingHours: 'Jam Kerja 08:00 – 17:00',
                        checkIn: activity.title == 'Check In' ? activity.time : '08:00',
                        checkOut: activity.title == 'Check Out' ? activity.time : '17:00',
                        isLate: activity.title == 'Check In' ? activity.isTimeWarning : false,
                        isEarlyOut: activity.title == 'Check Out' ? activity.isTimeWarning : false,
                      );
                      context.push('/attendance-detail', extra: dummyEntry);
                    },
                  )),
              const SizedBox(height: 16),
              _buildSectionHeader(
                title: AppStrings.announcement,
                onTap: () {},
              ),
              ...announcements.map((announcement) => AnnouncementCard(
                    title: announcement.title,
                    description: announcement.description,
                    date: announcement.date,
                  )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4.0),
            child: Row(
              children: [
                Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.bodySmallBold.copyWith(
                    color: AppColors.primaryBlueStart,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primaryBlueStart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
