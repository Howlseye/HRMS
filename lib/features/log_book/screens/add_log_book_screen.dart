import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/task_item_model.dart';
import '../providers/log_book_provider.dart';


class AddLogBookScreen extends ConsumerStatefulWidget {
  const AddLogBookScreen({super.key});

  @override
  ConsumerState<AddLogBookScreen> createState() => _AddLogBookScreenState();
}

class _AddLogBookScreenState extends ConsumerState<AddLogBookScreen> {
  final List<TaskItem> _tasks = [];
  bool _isDetailExpanded = false;

  String get _currentDate {
    final now = DateTime.now();
    final monthName = AppStrings.monthNames[now.month - 1];
    return '${now.day} $monthName ${now.year}';
  }

  int get _totalHours {
    int h = 0;
    int m = 0;
    for (final task in _tasks) {
      h += task.hours;
      m += task.minutes;
    }
    return h + (m ~/ 60);
  }

  int get _totalMinutes {
    int m = 0;
    for (final task in _tasks) {
      m += task.minutes;
    }
    return m % 60;
  }

  String get _totalDurationString {
    final h = _totalHours;
    final m = _totalMinutes;
    final hStr = h > 0 ? '$h ${AppStrings.hoursLabel} ' : '';
    final mStr = m > 0 ? '$m ${AppStrings.minutesLabel}' : '';
    final result = '$hStr$mStr'.trim();
    return result.isEmpty ? '0 ${AppStrings.hoursLabel}' : result;
  }

  void _openAddTaskScreen({TaskItem? initialTask, int? index}) async {
    final result = await context.push<dynamic>('/add-task', extra: initialTask);
    if (result == 'DELETE') {
      if (index != null && index >= 0 && index < _tasks.length) {
        setState(() {
          _tasks.removeAt(index);
        });
      }
    } else if (result is TaskItem) {
      setState(() {
        if (index != null && index >= 0 && index < _tasks.length) {
          _tasks[index] = result;
        } else {
          _tasks.add(result);
        }
      });
    }
  }



  void _showSubmitLogBookPopup() {
    showDialog(
      context: context,
      builder: (dialogContext) => AppPopup(
        svgAsset: AppAssets.popupInfoIcon,
        iconColor: AppColors.primaryBlueStart,
        title: AppStrings.submitLogBookPopupTitle,
        description: AppStrings.submitLogBookPopupDesc,
        primaryButtonText: AppStrings.lanjutkan,
        secondaryButtonText: AppStrings.batal,
        primaryButtonColor: AppColors.primaryBlueStart,
        onPrimaryPressed: () {
          Navigator.of(dialogContext).pop();
          
          final activitiesList = _tasks.map((t) => t.typesString).toList();
          final summaryText = _tasks.map((t) => t.summary).join('\n');
          final constraintsText = _tasks.map((t) => t.constraints).where((c) => c.isNotEmpty).join('\n');

          context.push('/add-log-book-success', extra: {
            'activities': activitiesList,
            'summary': summaryText,
            'constraint': constraintsText,
          });
        },
        onSecondaryPressed: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

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
    final targetDateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final logBookData = ref.watch(logBookDataProvider(targetDateFormatted)).value;
    final timesheet = logBookData?.template.timesheet;
    final name = timesheet?.employeeName.isNotEmpty == true ? timesheet!.employeeName : AppStrings.dummyFullName;
    final customer = timesheet?.customer.isNotEmpty == true ? timesheet!.customer : AppStrings.dash;
    final period = timesheet != null ? _formatPeriod(timesheet.periodStart, timesheet.periodEnd) : AppStrings.dash;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.dailyLogTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textDark,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 32.0,
                      ),
                      child: IntrinsicHeight(
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
                                    _currentDate,
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
                                        AppStrings.dash,
                                        style: AppTextStyles.bodyMediumBold.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  StatusBadge(
                                    text: AppStrings.statusDraft,
                                    textColor: AppColors.textWarning,
                                    backgroundColor: AppColors.menuBgOrangeLight,
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
                                color: AppColors.menuBgBlue,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: AppColors.primaryBlueStart,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppStrings.addOrFixTaskBannerMsg,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primaryBlueStart,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: AppColors.bgWhite,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: AppColors.borderLight),
                                ),
                                child: Column(
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
                                      AppStrings.taskWorkedTodaySubtitle,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (_tasks.isEmpty)
                                      Expanded(
                                        child: Center(
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
                                              const SizedBox(height: 20),
                                              OutlinedButton.icon(
                                                onPressed: () => _openAddTaskScreen(),
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: AppColors.primaryBlueStart,
                                                ),
                                                label: Text(
                                                  AppStrings.addTaskBtn,
                                                  style: AppTextStyles.bodyMediumBold.copyWith(
                                                    color: AppColors.primaryBlueStart,
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: AppColors.primaryBlueStart,
                                                  side: const BorderSide(
                                                    color: AppColors.primaryBlueStart,
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else ...[
                                      _buildSummaryTaskCard(),
                                      const SizedBox(height: 12),
                                      ..._tasks.asMap().entries.map((entry) => _buildTaskCard(entry.value, entry.key)),
                                      const SizedBox(height: 12),
                                      Center(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _openAddTaskScreen(),
                                          icon: const Icon(
                                            Icons.add,
                                            size: 16,
                                            color: AppColors.primaryBlueStart,
                                          ),
                                          label: Text(
                                            AppStrings.addTaskBtn,
                                            style: AppTextStyles.bodyMediumBold.copyWith(
                                              color: AppColors.primaryBlueStart,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.primaryBlueStart,
                                            side: const BorderSide(
                                              color: AppColors.primaryBlueStart,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: CustomButton(
                text: AppStrings.btnSubmit,
                onPressed: _tasks.isNotEmpty ? _showSubmitLogBookPopup : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTaskCard() {
    return Container(
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
                '${_tasks.length}',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _totalDurationString,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task, int index) {
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
                  text: AppStrings.statusSaved,
                  textColor: AppColors.textSuccess,
                  backgroundColor: AppColors.menuBgGreen,
                ),
                InkWell(
                  onTap: () => _openAddTaskScreen(initialTask: task, index: index),
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
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
                _buildTaskFieldItem(AppStrings.durationLabel, task.durationString),
                const SizedBox(height: 12),
                _buildTaskFieldItem(AppStrings.taskTypeLabel, task.typesString),
                const SizedBox(height: 12),
                _buildTaskFieldItem(AppStrings.taskSummaryLabel, task.summary),
                const SizedBox(height: 12),
                _buildTaskFieldItem(
                  AppStrings.constraints,
                  task.constraints.isEmpty ? '-' : task.constraints,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFieldItem(String label, String value) {
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
            color: AppColors.textPrimary,
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
