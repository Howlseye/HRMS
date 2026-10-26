import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../providers/home_provider.dart';
import '../widgets/home_header.dart';
import '../../../core/widgets/attendance_card.dart';
import '../widgets/quick_action_menu.dart';
import '../widgets/approval_daily_log_summary.dart';
import '../widgets/home_section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../announcement/providers/announcement_provider.dart';
import '../../announcement/widgets/announcement_card.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../../attendance/providers/current_shift_provider.dart';
import '../../../core/widgets/app_error_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementProvider);
    final currentEmployeeAsync = ref.watch(currentEmployeeProvider);
    final _ = ref.watch(currentShiftProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: currentEmployeeAsync.when(
          loading: () => Center(
            child: Lottie.asset(
              AppAssets.loadingLottie,
              width: 150,
            ),
          ),
          error: (error, stack) => Center(
            child: AppErrorWidget(
              errorMessage: error.toString().replaceAll('Exception: ', ''),
              onRetry: () {
                ref.invalidate(currentEmployeeProvider);
                ref.invalidate(currentShiftProvider);
                ref.invalidate(activityProvider);
              },
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
                  if (employee.role.toLowerCase() == 'hr manager') ...[
                    HomeSectionHeader(
                      title: AppStrings.approvalDailyLog,
                      onTap: () {
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: ApprovalDailyLogSummary(
                        waitingCount: 48,
                        totalParticipants: 123,
                        notSubmitCount: 1,
                        onReviewTap: () {
                        },
                      ),
                    ),
                  ],
                  HomeSectionHeader(
                    title: AppStrings.todaysActivity,
                    onTap: () {
                      context.push('/attendance-log');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColors.menuBgBlue,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.primaryBlueStart,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  AppStrings.todayActivityInfoMsg,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primaryBlueStart,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            context.push('/add-log-book');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              color: AppColors.bgWhite,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppStrings.dummyDate4,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                StatusBadge(
                                  text: AppStrings.statusDraft,
                                  textColor: AppColors.textWarning,
                                  backgroundColor: AppColors.menuBgOrangeLight,
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.iconNavy,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                              AppAssets.emptyData,
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
