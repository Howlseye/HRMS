import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/log_book_entry.dart';
import '../widgets/export_log_book_bottom_sheet.dart';

class LogBookScreen extends ConsumerWidget {
  const LogBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dummyLogs = [
      LogBookEntry(date: AppStrings.dummyDate1, status: AppStrings.statusApproved, checkInTime: '07:59', checkOutTime: '17:15', activities: 'Development, Bug fixing', detail: '...', constraints: '-', rejectReason: null),
      LogBookEntry(date: AppStrings.dummyDate2, status: AppStrings.statusApproved, checkInTime: '07:59', checkOutTime: '17:15', activities: 'Development, Bug fixing', detail: '...', constraints: '-', rejectReason: null),
      LogBookEntry(date: AppStrings.dummyDate3, status: AppStrings.statusApproved, checkInTime: '07:59', checkOutTime: '17:15', activities: 'Development, Bug fixing', detail: '...', constraints: '-', rejectReason: null),
      LogBookEntry(date: AppStrings.dummyDate4, status: AppStrings.statWaiting, checkInTime: '07:59', checkOutTime: '17:15', activities: 'Development, Bug fixing', detail: '...', constraints: '-', rejectReason: null),
      LogBookEntry(date: AppStrings.dummyDate5, status: AppStrings.statRejected, checkInTime: '07:59', checkOutTime: '17:15', activities: 'Development, Bug fixing', detail: '...', constraints: '-', rejectReason: 'Terdapat log yang tidak sesuai'),
      LogBookEntry(date: AppStrings.dummyDate6, status: AppStrings.statusNotStarted, checkInTime: '', checkOutTime: '', activities: '', detail: '', constraints: '', rejectReason: null),
    ];

    int totalWorkingDays = 20;
    int waitingCount = dummyLogs.where((log) => log.status == AppStrings.statWaiting).length;
    int rejectedCount = dummyLogs.where((log) => log.status == AppStrings.statRejected).length;
    int recordedCount = dummyLogs.where((log) => log.status == AppStrings.statusApproved).length;
    double progress = totalWorkingDays > 0 ? recordedCount / totalWorkingDays : 0.0;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.logBookTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
        leading: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
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
                        AppStrings.dummyMonth,
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
                                  color: AppColors.menuBgOrangeLight,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.hourglass_empty,
                                  color: AppColors.iconYellow,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.statWaiting,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.iconGray,
                                    ),
                                  ),
                                  Text(
                                    waitingCount.toString(),
                                    style: AppTextStyles.headingSmall.copyWith(
                                      color: AppColors.textPrimary,
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
              const SizedBox(height: 24),


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


              ...dummyLogs.map((log) {
                Color statusColor;
                Color statusBgColor;

                switch (log.status) {
                  case AppStrings.statusApproved:
                    statusColor = AppColors.textSuccess;
                    statusBgColor = AppColors.menuBgGreen;
                    break;
                  case AppStrings.statWaiting:
                    statusColor = AppColors.iconYellow;
                    statusBgColor = AppColors.menuBgOrangeLight;
                    break;
                  case AppStrings.statRejected:
                    statusColor = AppColors.textDanger;
                    statusBgColor = AppColors.menuBgPink;
                    break;
                  default:
                    statusColor = AppColors.iconDisabled;
                    statusBgColor = AppColors.menuBgGray;
                }

                return _buildLogItem(context, log, statusColor, statusBgColor);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(BuildContext context, LogBookEntry entry, Color statusColor, Color statusBgColor) {
    return GestureDetector(
      onTap: () {
        if (entry.status == AppStrings.statusNotStarted) return;
        
        context.push('/log-book-detail', extra: entry);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(10),
        ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.date,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          StatusBadge(
            text: entry.status,
            textColor: statusColor,
            backgroundColor: statusBgColor,
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.chevron_right,
            color: AppColors.iconNavy,
            size: 20,
          ),
        ],
      ),
    ),
  );
}
}
