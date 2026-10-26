import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/month_year_picker_bottom_sheet.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/log_book_entry.dart';
import 'export_log_book_bottom_sheet.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../providers/log_book_provider.dart';

class LogBookEmployeeView extends ConsumerStatefulWidget {
  const LogBookEmployeeView({super.key});

  @override
  ConsumerState<LogBookEmployeeView> createState() => _LogBookEmployeeViewState();
}

class _LogBookEmployeeViewState extends ConsumerState<LogBookEmployeeView> {
  DateTime _selectedDate = DateTime(2026, 8);

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return MonthYearPickerBottomSheet(
          initialDate: _selectedDate,
          allowFutureMonths: true,
          onDateSelected: (newDate) {
            setState(() {
              _selectedDate = newDate;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthName = AppStrings.monthNames[_selectedDate.month - 1];
    final formattedMonth = '$monthName ${_selectedDate.year}';

    final targetDateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final dataAsync = ref.watch(logBookDataProvider(targetDateFormatted));

    return dataAsync.when(
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
            ref.invalidate(logBookDataProvider);
          },
        ),
      ),
      data: (logBookData) {
        final templateData = logBookData.template;
        final timesheetDetail = logBookData.timesheetDetail?.data;
        final approvals = logBookData.approvals;

        DateTime startDate = DateTime.now();
        DateTime endDate = DateTime.now();
        int totalWorkingDays = 20;

        try {
          startDate = DateTime.parse(templateData.timesheet.periodStart);
          endDate = DateTime.parse(templateData.timesheet.periodEnd);
          totalWorkingDays = endDate.difference(startDate).inDays + 1;
        } catch (_) {}

        List<LogBookEntry> activeLogs = [];
        LogBookEntry? todayLogEntry;
        int missedCount = 0;
        int rejectedCount = 0;
        int recordedCount = 0;

        final todayDateOnly = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

        for (int i = 0; i < totalWorkingDays; i++) {
          final currentDate = startDate.add(Duration(days: i));
          final dateString = DateFormat('yyyy-MM-dd').format(currentDate);
          
          final dailyLogs = timesheetDetail?.timeLogs
                  .where((log) => log.fromTime.startsWith(dateString))
                  .toList() ??
              [];

          String status = '';
          String activities = '';
          String detail = '';
          String checkInTime = '';
          String checkOutTime = '';

          final matchingApproval = approvals.where((a) => a.date == dateString).firstOrNull;

          if (matchingApproval != null) {
            final approvalStatus = matchingApproval.status.toLowerCase();
            if (approvalStatus == 'approved') {
              status = AppStrings.statusApproved;
              recordedCount++;
            } else if (approvalStatus == 'rejected') {
              status = AppStrings.statRejected;
              rejectedCount++;
            } else if (approvalStatus == 'draft') {
              status = AppStrings.statWaiting;
            } else {
              status = matchingApproval.status;
            }
          } else {
            if (currentDate.isBefore(todayDateOnly)) {
              status = AppStrings.statMissed;
              missedCount++;
            } else if (currentDate.isAtSameMomentAs(todayDateOnly)) {
              status = AppStrings.statusDraft;
            } else {
              status = AppStrings.statusNotStarted;
            }
          }

          if (dailyLogs.isNotEmpty) {
            activities = dailyLogs.map((e) => e.parsedTemplateData['project_id'] ?? AppStrings.taskLabel).join(', ');
            detail = dailyLogs.map((e) => e.parsedTemplateData['work_description'] ?? '').join('\n');
            
            try {
              checkInTime = DateFormat('HH:mm').format(DateTime.parse(dailyLogs.first.fromTime));
              checkOutTime = DateFormat('HH:mm').format(DateTime.parse(dailyLogs.last.toTime));
            } catch (_) {}
          }

          final dayName = AppStrings.shortDayNames[currentDate.weekday - 1];
          final monthNameStr = AppStrings.monthNames[currentDate.month - 1];
          final displayDate = '$dayName, ${currentDate.day.toString().padLeft(2, '0')} $monthNameStr ${currentDate.year}';

          final newEntry = LogBookEntry(
            date: displayDate,
            rawDate: currentDate,
            status: status,
            checkInTime: checkInTime,
            checkOutTime: checkOutTime,
            activities: activities,
            detail: detail,
            constraints: '', 
            rejectReason: null,
          );

          if (currentDate.isAtSameMomentAs(todayDateOnly)) {
            todayLogEntry = newEntry;
          } else {
            activeLogs.add(newEntry);
          }
        }

        activeLogs = activeLogs.reversed.toList();
        double progress = totalWorkingDays > 0 ? recordedCount / totalWorkingDays : 0.0;

        return CustomRefreshIndicator(
          onRefresh: () async {
            ref.invalidate(logBookDataProvider);
            try {
              await ref.read(logBookDataProvider(targetDateFormatted).future);
            } catch (_) {}
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            children: [
              GestureDetector(
                onTap: _showMonthPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: AppColors.bgWhite,
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: AppColors.iconNavy,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formattedMonth,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 136,
                  decoration: BoxDecoration(
                    color: AppColors.bgWhite,
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: AppColors.menuBgBlue,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textSuccess),
                            strokeCap: StrokeCap.square,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$recordedCount/$totalWorkingDays',
                                style: AppTextStyles.headingExtraBold.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppStrings.statDaysRecorded,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        border: Border.all(color: AppColors.borderLight),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.menuBgMissed,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.assignment_late_outlined,
                              color: AppColors.textMissed,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.statMissed,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.iconGray,
                                ),
                              ),
                              Text(
                                missedCount.toString(),
                                style: AppTextStyles.headingSmall.copyWith(
                                  color: AppColors.textMissed,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        border: Border.all(color: AppColors.borderLight),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.menuBgPink,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.cancel_presentation,
                              color: AppColors.textDanger,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.statRejected,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.iconGray,
                                ),
                              ),
                              Text(
                                rejectedCount.toString(),
                                style: AppTextStyles.headingSmall.copyWith(
                                  color: AppColors.textDanger,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
              const SizedBox(height: 20),
                Text(
                  AppStrings.todaysActivity,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
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
                if (todayLogEntry != null) ...[
                  Builder(
                    builder: (context) {
                      final currentTodayEntry = todayLogEntry!;
                      Color statusColor;
                      Color statusBgColor;

                      switch (currentTodayEntry.status) {
                        case AppStrings.statusApproved:
                          statusColor = AppColors.textSuccess;
                          statusBgColor = AppColors.menuBgGreen;
                          break;
                        case AppStrings.statWaiting:
                          statusColor = AppColors.textWarning;
                          statusBgColor = AppColors.menuBgYellow;
                          break;
                        case AppStrings.statRejected:
                          statusColor = AppColors.textDanger;
                          statusBgColor = AppColors.menuBgPink;
                          break;
                        case AppStrings.statusDraft:
                          statusColor = AppColors.textWarning;
                          statusBgColor = AppColors.menuBgOrangeLight;
                          break;
                        default:
                          statusColor = AppColors.iconDisabled;
                          statusBgColor = AppColors.menuBgGray;
                      }

                      return GestureDetector(
                        onTap: () {
                          if (currentTodayEntry.status == AppStrings.statusDraft) {
                            context.push('/add-log-book');
                          } else {
                            context.push('/log-book-detail', extra: {
                              'entry': currentTodayEntry,
                              'timesheet': templateData.timesheet,
                            });
                          }
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
                                  currentTodayEntry.date,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              StatusBadge(
                                text: currentTodayEntry.status,
                                textColor: statusColor,
                                backgroundColor: statusBgColor,
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
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.listDailyLog,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const ExportLogBookBottomSheet(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          border: Border.all(color: AppColors.primaryBlueStart),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.file_download_outlined,
                              color: AppColors.primaryBlueStart,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppStrings.btnExport,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryBlueStart,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...activeLogs.map((log) {
                  Color statusColor;
                  Color statusBgColor;

                  switch (log.status) {
                    case AppStrings.statusApproved:
                      statusColor = AppColors.textSuccess;
                      statusBgColor = AppColors.menuBgGreen;
                      break;
                    case AppStrings.statWaiting:
                      statusColor = AppColors.textWarning;
                      statusBgColor = AppColors.menuBgYellow;
                      break;
                    case AppStrings.statRejected:
                      statusColor = AppColors.textDanger;
                      statusBgColor = AppColors.menuBgPink;
                      break;
                    case AppStrings.statMissed:
                      statusColor = AppColors.textMissed;
                      statusBgColor = AppColors.menuBgMissed;
                      break;
                    case AppStrings.statusDraft:
                      statusColor = AppColors.textWarning;
                      statusBgColor = AppColors.menuBgOrangeLight;
                      break;
                    default:
                      statusColor = AppColors.iconDisabled;
                      statusBgColor = AppColors.menuBgGray;
                  }

                  return GestureDetector(
                    onTap: () {
                      if (log.status != AppStrings.statusNotStarted) {
                        context.push('/log-book-detail', extra: {
                          'entry': log,
                          'timesheet': templateData.timesheet,
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
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
                              log.date,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          StatusBadge(
                            text: log.status,
                            textColor: statusColor,
                            backgroundColor: statusBgColor,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: log.status == AppStrings.statusNotStarted
                                ? AppColors.borderDivider
                                : AppColors.iconNavy,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
    });
  }
}
