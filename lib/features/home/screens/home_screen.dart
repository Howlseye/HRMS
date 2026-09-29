import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../providers/home_provider.dart';
import '../widgets/home_header.dart';
import '../../../core/widgets/attendance_card.dart';
import '../widgets/quick_action_menu.dart';
import '../widgets/home_section_header.dart';
import '../../../core/widgets/attendance_activity_card.dart';
import '../../announcement/providers/announcement_provider.dart';
import '../../announcement/widgets/announcement_card.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../../attendance/providers/current_shift_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityProvider);
    final announcements = ref.watch(announcementProvider);
    final currentEmployeeAsync = ref.watch(currentEmployeeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: currentEmployeeAsync.when(
          loading: () => Center(
            child: Lottie.asset(
              'assets/lottie/loading.json',
              width: 150,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.errorServerSide,
                  style: AppTextStyles.headingSmall.copyWith(color: AppColors.textDanger),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.errorDataNotFound,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          data: (employee) => CustomRefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentEmployeeProvider);
              ref.invalidate(currentShiftProvider);
              ref.invalidate(activityProvider);
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(employee: employee),
                  const AttendanceCard(),
                  const QuickActionMenu(),
                  HomeSectionHeader(
                    title: AppStrings.todaysActivity,
                    onTap: () {
                      context.push('/attendance-log');
                    },
                  ),
                  ...activitiesAsync.when(
                    data: (activities) => activities.isEmpty 
                      ? [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              decoration: BoxDecoration(
                                color: AppColors.bgWhite,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/empty_data.svg',
                                    height: 64,
                                    width: 78,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    AppStrings.emptyActivity,
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconDisabled),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]
                      : activities.map((activity) => AttendanceActivityCard(
                        icon: activity.icon,
                        title: activity.title,
                        date: activity.date,
                        time: activity.time,
                        iconColor: activity.iconColor,
                        iconBgColor: activity.iconBgColor,
                        isTimeWarning: activity.isTimeWarning,
                      )).toList(),
                    loading: () => [
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(child: CircularProgressIndicator(color: AppColors.primaryBlueStart)),
                      ),
                    ],
                    error: (err, stack) => [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          AppStrings.errorServerSide,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDanger),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  HomeSectionHeader(
                    title: AppStrings.announcement,
                    onTap: () {
                      context.push('/announcement');
                    },
                  ),
                  if (announcements.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/empty_data.svg',
                              height: 64,
                              width: 78,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppStrings.noAnnouncement,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconDisabled),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...announcements.take(3).map((announcement) => AnnouncementCard(
                          title: announcement.title,
                          description: announcement.description,
                          date: announcement.date,
                          onTap: () => context.push('/announcement/detail', extra: announcement),
                        )),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
