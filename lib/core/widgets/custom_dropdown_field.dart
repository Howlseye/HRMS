import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textPrimary),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.textDanger),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return PopupMenuButton<String>(
              offset: const Offset(0, 48),
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              color: AppColors.bgWhite,
              elevation: 4,
              onSelected: onChanged,
              itemBuilder: (context) {
                return items.map((item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    ),
                  );
                }).toList();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value ?? hintText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: value == null ? AppColors.iconDisabled : AppColors.textPrimary,
                      ),
                    ),
                    const Icon(
                      Icons.expand_more,
                      color: AppColors.iconDisabled,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
