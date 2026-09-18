import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

class MonthYearPickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool allowFutureMonths;

  const MonthYearPickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.allowFutureMonths = false,
  });

  @override
  State<MonthYearPickerBottomSheet> createState() => _MonthYearPickerBottomSheetState();
}

class _MonthYearPickerBottomSheetState extends State<MonthYearPickerBottomSheet> {
  bool isYearView = false;
  late DateTime filterDate;

  @override
  void initState() {
    super.initState();
    filterDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      height: 484,
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dragHandle,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => setState(() => isYearView = false),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: !isYearView ? AppColors.textPrimary.withValues(alpha: 0.08) : AppColors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Text(
                          AppStrings.monthNames[filterDate.month - 1].substring(0, 3),
                          style: AppTextStyles.bodyMediumSemiBold.copyWith(color: AppColors.textPrimary),
                        ),
                        if (!isYearView) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => isYearView = true),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isYearView ? AppColors.textPrimary.withValues(alpha: 0.08) : AppColors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${filterDate.year}',
                          style: AppTextStyles.bodyMediumSemiBold.copyWith(color: AppColors.textPrimary),
                        ),
                        if (isYearView) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          Expanded(
            child: isYearView
                ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final year = now.year - index;
                      final isSelected = filterDate.year == year;
                      return InkWell(
                        onTap: () {
                          int selectedMonth = filterDate.month;
                          if (!widget.allowFutureMonths && year == now.year && selectedMonth > now.month) {
                            selectedMonth = now.month;
                          }
                          setState(() {
                            filterDate = DateTime(year, selectedMonth);
                            isYearView = false;
                          });
                          widget.onDateSelected(filterDate);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          child: Text(
                            '$year',
                            style: AppTextStyles.title.copyWith(
                              color: isSelected ? AppColors.primaryBlueStart : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w700 : null,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: AppStrings.monthNames.length,
                    itemBuilder: (context, index) {
                      final monthIndex = index + 1;
                      final isFuture = !widget.allowFutureMonths && filterDate.year == now.year && monthIndex > now.month;
                      final isSelected = filterDate.month == monthIndex;

                      return InkWell(
                        onTap: isFuture
                            ? null
                            : () {
                                setState(() {
                                  filterDate = DateTime(filterDate.year, monthIndex);
                                });
                                widget.onDateSelected(filterDate);
                                context.pop();
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          child: Text(
                            AppStrings.monthNames[index],
                            style: AppTextStyles.title.copyWith(
                              color: isFuture
                                  ? AppColors.textSecondary.withValues(alpha: 0.3)
                                  : (isSelected ? AppColors.primaryBlueStart : AppColors.textPrimary),
                              fontWeight: isSelected ? FontWeight.w700 : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
