import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';
import 'month_year_picker_bottom_sheet.dart';

class MonthYearFilterBar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final bool showFilterIcon;
  final VoidCallback? onFilterTapped;
  final bool allowFutureMonths;

  const MonthYearFilterBar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.showFilterIcon = true,
    this.onFilterTapped,
    this.allowFutureMonths = false,
  });

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return MonthYearPickerBottomSheet(
          initialDate: selectedDate,
          onDateSelected: onDateChanged,
          allowFutureMonths: allowFutureMonths,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthName = AppStrings.monthNames[selectedDate.month - 1];

    return Row(
      children: [
        Expanded(
          child: Material(
            color: AppColors.bgWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: AppColors.borderLight),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => _showMonthPicker(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, color: AppColors.iconNavy, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$monthName ${selectedDate.year}',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.expand_more, color: AppColors.textSecondary, size: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showFilterIcon) ...[
          const SizedBox(width: 8),
          Material(
            color: AppColors.bgWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: AppColors.borderLight),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onFilterTapped,
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.filter_alt_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
