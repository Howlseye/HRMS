import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/attendance_activity_card.dart';
import '../../../core/widgets/attendance_card.dart';
import '../providers/attendance_provider.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(attendanceHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBlueStart,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlueStart,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.titleAttendance,
          style: AppTextStyles.title.copyWith(
            color: AppColors.textWhite,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const AttendanceCard(transparentBackground: true),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 24.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.historyAttendance,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.push('/attendance-log');
                          },
                          borderRadius: BorderRadius.circular(4.0),
                          child: Row(
                            children: [
                              Text(
                                AppStrings.logActivity,
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
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(attendanceHistoryProvider);
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      color: AppColors.primaryBlueStart,
                      backgroundColor: AppColors.bgWhite,
                      child: historyAsync.when(
                        data: (history) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                              left: 24.0, right: 24.0, bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (history.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                                    child: Text(
                                      AppStrings.emptyActivity,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconDisabled),
                                    ),
                                  ),
                                )
                              else
                                ...history.map((activity) => AttendanceActivityCard(
                                  icon: activity.icon,
                                  title: activity.title,
                                  date: activity.date,
                                  time: activity.time,
                                  iconColor: activity.iconColor,
                                  iconBgColor: activity.iconBgColor,
                                  isTimeWarning: activity.isTimeWarning,
                                  margin: const EdgeInsets.only(bottom: 12.0),
                                )),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: AppColors.primaryBlueStart),
                        ),
                        error: (error, stack) => Center(
                          child: Text(
                            AppStrings.errorServerSide,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDanger),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
