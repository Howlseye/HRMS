import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);
    final rememberMe = ref.watch(rememberMeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
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
                AppStrings.welcome,
                style: AppTextStyles.displayMediumHeavy.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: AppStrings.emailLabel,
                hintText: AppStrings.emailHint,
                isRequired: true,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.passwordLabel,
                hintText: AppStrings.passwordHint,
                isPassword: true,
                isRequired: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        ref
                            .read(rememberMeProvider.notifier)
                            .toggle(value ?? false);
                      },
                      activeColor: AppColors.primaryBlueStart,
                      side: const BorderSide(color: AppColors.iconDisabled),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.rememberMe,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: AppStrings.signIn,
                isLoading: isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref
                        .read(authControllerProvider)
                        .login(_emailController.text, _passwordController.text)
                        .then((_) {
                      if (context.mounted) {
                        context.go('/main');
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: AppStrings.forgotPassword,
                isOutlined: true,
                onPressed: () {
                  context.push('/forgot-password');
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
