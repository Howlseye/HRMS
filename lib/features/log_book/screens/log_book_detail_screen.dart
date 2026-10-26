import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/log_book_entry.dart';
import '../models/log_book_template_model.dart';
import '../providers/log_book_provider.dart';

class LogBookDetailScreen extends ConsumerStatefulWidget {
  final LogBookEntry logEntry;
  final String? employeeName;
  final String? employeeRole;
  final TimesheetInfo? timesheet;

  const LogBookDetailScreen({
    super.key,
    required this.logEntry,
    this.employeeName,
    this.employeeRole,
    this.timesheet,
  });

  @override
  ConsumerState<LogBookDetailScreen> createState() => _LogBookDetailScreenState();
}

class _LogBookDetailScreenState extends ConsumerState<LogBookDetailScreen> {
  bool _isDetailExpanded = false;

  String _formatPeriod(String startStr, String endStr) {
    try {
      final start = DateTime.parse(startStr);
      final end = DateTime.parse(endStr);
      final startMonth = AppStrings.monthNames[start.month - 1];
      final endMonth = AppStrings.monthNames[end.month - 1];
      if (start.year == end.year) {
        if (start.month == end.month) {
          return '${start.day} - ${end.day} $endMonth ${end.year}';
        }
        return '${start.day} $startMonth - ${end.day} $endMonth ${end.year}';
      }
      return '${start.day} $startMonth ${start.year} - ${end.day} $endMonth ${end.year}';
    } catch (_) {
      if (startStr.isNotEmpty && endStr.isNotEmpty) {
        return '$startStr - $endStr';
      }
      return AppStrings.dash;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;

    final isWaiting = widget.logEntry.status.toLowerCase() == 'waiting';

    switch (widget.logEntry.status.toLowerCase()) {
      case 'approved':
        statusColor = AppColors.textSuccess;
        statusBgColor = AppColors.menuBgGreen;
        break;
      case 'waiting':
        statusColor = AppColors.textWarning;
        statusBgColor = AppColors.menuBgYellow;
        break;
      case 'rejected':
        statusColor = AppColors.textDanger;
        statusBgColor = AppColors.menuBgPink;
        break;
      case 'missed':
        statusColor = AppColors.textMissed;
        statusBgColor = AppColors.menuBgMissed;
        break;
      case 'draft':
        statusColor = AppColors.textWarning;
        statusBgColor = AppColors.menuBgOrangeLight;
        break;
      default:
        statusColor = AppColors.iconDisabled;
        statusBgColor = AppColors.menuBgGray;
    }

    final targetDateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final logBookData = ref.watch(logBookDataProvider(targetDateFormatted)).value;
    final timesheet = widget.timesheet ?? logBookData?.template.timesheet;

    final name = widget.employeeName ??
        (timesheet?.employeeName.isNotEmpty == true
            ? timesheet!.employeeName
            : AppStrings.dummyFullName);
    final customer = timesheet?.customer.isNotEmpty == true
        ? timesheet!.customer
        : AppStrings.dash;
    final period = timesheet != null
        ? _formatPeriod(timesheet.periodStart, timesheet.periodEnd)
        : AppStrings.dash;
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final isPast = widget.logEntry.rawDate != null
        ? widget.logEntry.rawDate!.isBefore(todayDateOnly)
        : widget.logEntry.status.toLowerCase() == 'missed';
    final taskSubtitle = isPast
        ? AppStrings.taskWorkedPastSubtitle
        : AppStrings.taskWorkedTodaySubtitle;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.dailyLogTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textDark,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.menuBgBlue,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.logEntry.date,
                      style: AppTextStyles.titleBold.copyWith(
                        color: AppColors.primaryBlueStart,
                      ),
                    ),
                    const Icon(
                      Icons.date_range,
                      color: AppColors.primaryBlueStart,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.idLogBookLabel,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.iconGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.dummyIdLogBook,
                          style: AppTextStyles.bodyMediumBold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    StatusBadge(
                      text: widget.logEntry.status,
                      textColor: statusColor,
                      backgroundColor: statusBgColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isDetailExpanded = !_isDetailExpanded;
                        });
                      },
                      borderRadius: BorderRadius.circular(6.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.detailLogBookTitle,
                              style: AppTextStyles.bodyMediumBold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Icon(
                              _isDetailExpanded ? Icons.expand_less : Icons.expand_more,
                              color: AppColors.iconNavy,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isDetailExpanded) ...[
                      const Divider(color: AppColors.borderLight, height: 1),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildDetailRow(AppStrings.nameLabel, name),
                            const SizedBox(height: 10),
                            _buildDetailRow(AppStrings.customerLabel, customer),
                            const SizedBox(height: 10),
                            _buildDetailRow(AppStrings.periodLabel, period),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: widget.logEntry.status.toLowerCase() == 'missed' 
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.taskLabel,
                          style: AppTextStyles.titleBold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          taskSubtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.emptyData,
                                width: 120,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppStrings.noTaskYet,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.taskLabel,
                          style: AppTextStyles.titleBold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          taskSubtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColors.bgWhite,
                            border: Border.all(color: AppColors.borderLight),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.totalTaskLabel,
                                    style: AppTextStyles.bodyMediumBold.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    AppStrings.durationLabel,
                                    style: AppTextStyles.bodyMediumBold.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.dummySingleTaskCount,
                                    style: AppTextStyles.title.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    AppStrings.dummyDurationDetail,
                                    style: AppTextStyles.title.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildTaskCard(
                          widget.logEntry,
                          statusColor,
                          statusBgColor,
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isWaiting
          ? Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.textDanger),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor: AppColors.bgWhite,
                          ),
                          child: Text(
                            AppStrings.btnReject,
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColors.textDanger,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlueStart,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppStrings.btnApprove,
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildTaskCard(LogBookEntry logEntry, Color statusColor, Color statusBgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(
                  text: logEntry.status,
                  textColor: statusColor,
                  backgroundColor: statusBgColor,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: AppColors.filterChipBgActive,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskFieldItem(AppStrings.durationLabel, AppStrings.dummyDurationDetail),
                const SizedBox(height: 12),
                _buildTaskFieldItem(AppStrings.taskTypeLabel, logEntry.activities),
                const SizedBox(height: 12),
                _buildTaskFieldItem(AppStrings.taskSummaryLabel, logEntry.detail),
                const SizedBox(height: 12),
                _buildTaskFieldItem(
                  AppStrings.constraints,
                  logEntry.constraints.isEmpty ? '-' : logEntry.constraints,
                ),
                if (logEntry.status.toLowerCase() == 'rejected' && logEntry.rejectReason != null) ...[
                  const SizedBox(height: 12),
                  _buildTaskFieldItem(
                    AppStrings.rejectReasonLabel,
                    logEntry.rejectReason!,
                    isError: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFieldItem(String label, String value, {bool isError = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: isError ? AppColors.textDanger : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.iconGray,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmallSemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
