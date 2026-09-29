import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/month_year_filter_bar.dart';
import '../providers/attendance_log_provider.dart';
import '../widgets/attendance_stat_card.dart';
class AttendanceLogScreen extends ConsumerWidget {
  const AttendanceLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(attendanceLogProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.attendanceLog,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(builder: (context, ref, child) {
                final filterDate = ref.watch(attendanceFilterDateProvider);
                return MonthYearFilterBar(
                  selectedDate: filterDate,
                  onDateChanged: (newDate) {
                    ref.read(attendanceFilterDateProvider.notifier).updateDate(newDate);
                  },
                  showFilterIcon: false,
                );
              }),
              const SizedBox(height: 20),

              logs.when(
                data: (logData) {
                  final int terlambatCount = logData.where((log) => log.isLate).length;
                  final int pulangAwalCount = logData.where((log) => log.isEarlyOut).length;
                  final int cutiCount = 0;
                  final int tidakAbsenCount = logData.where((log) => log.checkIn == AppStrings.none && log.checkOut == AppStrings.none).length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          border: Border.all(color: AppColors.borderLight),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AttendanceStatCard(
                                    title: AppStrings.statCuti,
                                    value: cutiCount.toString(),
                                    icon: Icons.person_remove_outlined,
                                    iconColor: AppColors.textDanger,
                                    iconBgColor: AppColors.menuBgPink,
                                    hasBorderRight: true,
                                    hasBorderBottom: true,
                                  ),
                                ),
                                Expanded(
                                  child: AttendanceStatCard(
                                    title: AppStrings.statTerlambat,
                                    value: terlambatCount.toString(),
                                    icon: Icons.access_time_outlined,
                                    iconColor: AppColors.iconYellow,
                                    iconBgColor: AppColors.menuBgOrangeLight,
                                    hasBorderRight: false,
                                    hasBorderBottom: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AttendanceStatCard(
                                    title: AppStrings.statPulangAwal,
                                    value: pulangAwalCount.toString(),
                                    icon: Icons.directions_run,
                                    iconColor: AppColors.iconPurple,
                                    iconBgColor: AppColors.menuBgLavender,
                                    hasBorderRight: true,
                                    hasBorderBottom: false,
                                  ),
                                ),
                                Expanded(
                                  child: AttendanceStatCard(
                                    title: AppStrings.statTidakAbsen,
                                    value: tidakAbsenCount.toString(),
                                    icon: Icons.desktop_access_disabled,
                                    iconColor: AppColors.iconOrange,
                                    iconBgColor: AppColors.menuBgPeach,
                                    hasBorderRight: false,
                                    hasBorderBottom: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.attendanceList,
                            style: AppTextStyles.headingSmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.borderLight.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppStrings.totalDays(logData.length),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (logData.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: Text(
                              AppStrings.noAttendanceHistory,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        )
                      else
                        ...logData.map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Material(
                                color: AppColors.bgWhite,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => context.push('/attendance-detail', extra: entry),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            entry.date,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            entry.checkIn,
                                            style: AppTextStyles.bodyMediumExtraBold.copyWith(
                                              color: entry.isLate ? AppColors.textDanger : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            entry.checkOut,
                                            style: AppTextStyles.bodyMediumExtraBold.copyWith(
                                              color: entry.isEarlyOut ? AppColors.textDanger : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.iconNavy,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text(
                      AppStrings.errorLoadData,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDanger),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

}
