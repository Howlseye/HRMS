import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const StatusBadge({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
