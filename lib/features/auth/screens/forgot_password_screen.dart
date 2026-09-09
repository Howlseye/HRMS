import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(resetPasswordLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Row(
                children: [
                  Image.asset('assets/images/app_logo.png', height: 48),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.displayMediumHeavy.copyWith(
                      color: AppColors.primaryBlueStart,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.forgotPasswordTitle,
                style: AppTextStyles.displayMediumHeavy.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: AppStrings.emailLabel,
                hintText: AppStrings.emailHint,
                controller: _emailController,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: AppStrings.sendResetEmail,
                isLoading: isLoading,
                onPressed: () {
                  ref
                      .read(authControllerProvider)
                      .sendResetEmail(_emailController.text);
                },
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.spamNotice,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    AppStrings.backToLogin,
                    style: AppTextStyles.bodyMediumMedium.copyWith(
                      color: AppColors.primaryBlueStart,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
