import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

import '../../../core/widgets/success_screen.dart';

class SuccessLeaveScreen extends StatelessWidget {
  const SuccessLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: AppStrings.submissionSuccess,
      subtitleWidget: Text(
        AppStrings.submissionSuccessDesc,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        textAlign: TextAlign.center,
      ),
      buttonText: AppStrings.viewSubmission,
      onButtonPressed: () => context.pop(),
      onClosePressed: () => context.pop(),
    );
  }
}
