import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../models/reimbursement_model.dart';
import '../repositories/reimbursement_repository.dart';
import '../providers/reimbursement_provider.dart';

class ReimbursementCancelButton extends ConsumerWidget {
  final ReimbursementModel reimbursement;

  const ReimbursementCancelButton({
    super.key,
    required this.reimbursement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AppPopup(
              svgAsset: 'assets/icons/popup_cancel_icon.svg',
              title: AppStrings.cancelReimburseTitle,
              description: AppStrings.cancelReimburseDesc,
              primaryButtonText: AppStrings.confirmCancel,
              secondaryButtonText: AppStrings.cancel,
              primaryButtonColor: AppColors.textDanger,
              onPrimaryPressed: () async {
                Navigator.of(ctx).pop();

                try {
                  await ref.read(reimbursementRepositoryProvider).cancelReimbursement(reimbursement.id);
                  if (context.mounted) {
                    ref.invalidate(reimbursementProvider);
                    context.go('/reimbursement/cancel-success');
                  }
                } catch (e) {
                  if (context.mounted) {
                    AppSnackbar.show(
                      context,
                      message: e.toString().replaceAll('Exception: ', ''),
                      type: SnackbarType.error,
                    );
                  }
                }
              },
              onSecondaryPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.bgWhite,
          side: const BorderSide(color: AppColors.textDanger),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          AppStrings.cancelLeave,
          style: AppTextStyles.buttonText.copyWith(
            color: AppColors.textDanger,
          ),
        ),
      ),
    );
  }
}
