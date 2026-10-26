import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../../../core/widgets/month_year_picker_bottom_sheet.dart';
import '../../home/widgets/approval_daily_log_summary.dart';
import '../models/log_book_entry.dart';

class LogBookAdminView extends StatefulWidget {
  const LogBookAdminView({super.key});

  @override
  State<LogBookAdminView> createState() => _LogBookAdminViewState();
}

class _LogBookAdminViewState extends State<LogBookAdminView> {
  DateTime _selectedWeekStart = DateTime(2026, 7, 28);
  int _selectedDayOffset = 4;

  void _previousWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7));
    });
  }

  void _showMonthPicker() {
    final selectedCellDate = _selectedWeekStart.add(Duration(days: _selectedDayOffset));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return MonthYearPickerBottomSheet(
          initialDate: selectedCellDate,
          allowFutureMonths: true,
          onDateSelected: (newDate) {
            setState(() {
              final firstDayOfMonth = DateTime(newDate.year, newDate.month, 1);
              final dayOfWeek = firstDayOfMonth.weekday;
              _selectedWeekStart = firstDayOfMonth.subtract(Duration(days: dayOfWeek - 1));
              _selectedDayOffset = dayOfWeek - 1;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCellDate = _selectedWeekStart.add(Duration(days: _selectedDayOffset));
    final selectedMonthName = AppStrings.monthNames[selectedCellDate.month - 1];
    final formattedMonth = '$selectedMonthName ${selectedCellDate.year}';

    final bool isToday = (selectedCellDate.day == 1 && selectedCellDate.month == 8);
    final todayTitleText = isToday
        ? '${AppStrings.labelHariIni}, 1 Agustus 2026'
        : '${selectedCellDate.day} $selectedMonthName ${selectedCellDate.year}';

    final pendingApprovals = isToday
        ? [
            {'name': AppStrings.dummyEmpName1, 'role': AppStrings.dummyEmpRole1},
            {'name': AppStrings.dummyEmpName2, 'role': AppStrings.dummyEmpRole2},
            {'name': AppStrings.dummyEmpName3, 'role': AppStrings.dummyEmpRole3},
            {'name': AppStrings.dummyEmpName4, 'role': AppStrings.dummyEmpRole4},
            {'name': AppStrings.dummyEmpName5, 'role': AppStrings.dummyEmpRole5},
            {'name': AppStrings.dummyEmpName6, 'role': AppStrings.dummyEmpRole6},
            {'name': AppStrings.dummyEmpName7, 'role': AppStrings.dummyEmpRole7},
            {'name': AppStrings.dummyEmpName8, 'role': AppStrings.dummyEmpRole8},
            {'name': AppStrings.dummyEmpName9, 'role': AppStrings.dummyEmpRole9},
          ]
        : <Map<String, String>>[];

    return CustomRefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                      onPressed: _previousWeek,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    GestureDetector(
                      onTap: _showMonthPicker,
                      child: Text(
                        formattedMonth,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      onPressed: _nextWeek,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final cellDate = _selectedWeekStart.add(Duration(days: index));
                    final dayName = AppStrings.shortDayNames[index];
                    final isSelected = (_selectedDayOffset == index);
                    final isOutsideMonth = (cellDate.month != selectedCellDate.month);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayOffset = index;
                        });
                      },
                      child: _buildDayCell(
                        dayName,
                        '${cellDate.day}',
                        isSelected,
                        isOutsideMonth,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            todayTitleText,
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (isToday)
            ApprovalDailyLogSummary(
              waitingCount: 48,
              totalParticipants: 123,
              notSubmitCount: 1,
              onReviewTap: () {},
            )
          else ...[
            _buildNoApprovalCard(),
            const SizedBox(height: 8),
            _buildZeroApprovalSummaryBox(),
          ],
          const SizedBox(height: 16),
          ...pendingApprovals.map((item) => _buildPendingApprovalCard(
            name: item['name']!,
            role: item['role']!,
          )),
        ],
      ),
    );
  }

  Widget _buildDayCell(String day, String date, bool isSelected, bool isOutsideMonth) {
    Color textColor;
    if (isSelected) {
      textColor = AppColors.textWhite;
    } else if (isOutsideMonth) {
      textColor = AppColors.iconDisabled;
    } else {
      textColor = AppColors.textPrimary;
    }

    return Column(
      children: [
        Text(
          day,
          style: AppTextStyles.label.copyWith(
            color: AppColors.iconNavy,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlueStart : AppColors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            date,
            style: AppTextStyles.bodyMedium.copyWith(
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoApprovalCard() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: const Icon(
              Icons.menu_book_outlined,
              color: AppColors.primaryBlueStart,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.noApprovalTitle,
                      style: AppTextStyles.bodyMediumBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.textSuccess,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.allTalentApprovedSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.iconGray,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.iconNavy,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildZeroApprovalSummaryBox() {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryBoxItem(
              icon: Icons.group,
              iconBgColor: AppColors.menuBgBlue,
              iconColor: AppColors.primaryBlueStart,
              label: AppStrings.totalParticipants,
              value: AppStrings.totalParticipantsValue,
              hasRightBorder: true,
            ),
          ),
          Expanded(
            child: _buildSummaryBoxItem(
              icon: Icons.hourglass_empty,
              iconBgColor: AppColors.menuBgOrangeLight,
              iconColor: AppColors.iconYellow,
              label: AppStrings.waitingApprove,
              value: AppStrings.statWaitingValue,
              hasRightBorder: true,
            ),
          ),
          Expanded(
            child: _buildSummaryBoxItem(
              icon: Icons.cancel_presentation,
              iconBgColor: AppColors.menuBgGray,
              iconColor: AppColors.iconDisabled,
              label: AppStrings.notSubmit,
              value: AppStrings.dummySingleTaskCount,
              hasRightBorder: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBoxItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    required bool hasRightBorder,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: hasRightBorder
            ? const Border(right: BorderSide(color: AppColors.borderLight))
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.iconGray),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalCard({
    required String name,
    required String role,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/log-book-detail',
          extra: {
            'entry': LogBookEntry(
              date: AppStrings.dummyDateSeptember1,
              status: AppStrings.statWaiting,
              checkInTime: AppStrings.dummyTime0759,
              checkOutTime: AppStrings.dummyTime1715,
              activities: AppStrings.dummyLogActivity1,
              detail: AppStrings.dummyAdminDetailDesc,
              constraints: AppStrings.dummyConstraintLoginEmail,
            ),
            'employeeName': name,
            'employeeRole': role,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.menuBgGray),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.menuBgBlue,
              radius: 20,
              child: const Icon(Icons.person, color: AppColors.primaryBlueStart),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    role,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.iconGray,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.menuBgOrangeLight,
                border: Border.all(color: AppColors.iconYellow),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                AppStrings.statWaiting,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.iconYellow,
                ),
              ),
            ),
            const SizedBox(width: 12),
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
