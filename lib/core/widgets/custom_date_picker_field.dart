import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'custom_text_field.dart';

class CustomDatePickerField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onChanged;
  final Future<bool> Function()? onBeforeTap;

  const CustomDatePickerField({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.value,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.onBeforeTap,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    if (widget.onBeforeTap != null) {
      final canProceed = await widget.onBeforeTap!();
      if (!canProceed) return;
    }

    final DateTime now = DateTime.now();
    final DateTime first = widget.firstDate ?? DateTime(2000);
    final DateTime maxDate = widget.lastDate ?? DateTime(2101);
    
    final DateTime initial = widget.value ?? now;
    final DateTime validInitial = initial.isAfter(maxDate) 
        ? maxDate 
        : (initial.isBefore(first) ? first : initial);

    if (!context.mounted) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: validInitial,
      firstDate: first,
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryBlueStart,
              onPrimary: AppColors.textWhite,
              onSurface: AppColors.textPrimary,
              surface: AppColors.bgWhite,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.bgWhite,
              surfaceTintColor: AppColors.transparent,
              headerBackgroundColor: AppColors.bgWhite,
              weekdayStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlueStart,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && widget.onChanged != null) {
      widget.onChanged!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hintText: widget.value != null ? _formatDate(widget.value) : widget.hintText,
      isRequired: widget.isRequired,
      readOnly: true,
      onTap: () => _selectDate(context),
      suffixIcon: const Icon(
        Icons.date_range,
        color: AppColors.iconDisabled,
      ),
      controller: TextEditingController(
        text: widget.value != null ? _formatDate(widget.value) : null,
      ),
    );
  }
}
