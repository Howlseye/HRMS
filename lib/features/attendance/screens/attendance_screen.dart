import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/attendance_activity_card.dart';
import '../../../core/widgets/attendance_card.dart';
import '../models/attendance_log_entry.dart';
import '../providers/attendance_provider.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(attendanceHistoryProvider);

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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    ...history.map((activity) => AttendanceActivityCard(
                          icon: activity.icon,
                          title: activity.title,
                          date: activity.date,
                          time: activity.time,
                          iconColor: activity.iconColor,
                          iconBgColor: activity.iconBgColor,
                          isTimeWarning: activity.isTimeWarning,
                          margin: const EdgeInsets.only(bottom: 12.0),
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
                    const SizedBox(height: 32),
                        ],
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
