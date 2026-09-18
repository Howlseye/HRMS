import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/success_screen.dart';

class ReimbursementSuccessScreen extends StatelessWidget {
  const ReimbursementSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: AppStrings.submissionSuccess,
      subtitleWidget: Text(
        AppStrings.reimburseSuccessDesc,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      buttonText: AppStrings.viewSubmission,
      onButtonPressed: () {
        context.go('/reimbursement');
      },
      onClosePressed: () {
        context.go('/reimbursement');
      },
    );
  }
}
