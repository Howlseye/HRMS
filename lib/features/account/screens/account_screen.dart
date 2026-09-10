import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/account_menu_item.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                child: Text(
                  AppStrings.menuAccount,
                  style: AppTextStyles.headingExtraBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const ProfileCard(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  AppStrings.myActivity,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    AccountMenuItem(
                      icon: Icons.fact_check_outlined,
                      title: AppStrings.attendanceLog,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.assignment_outlined,
                      title: AppStrings.logBook,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  AppStrings.submission,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    AccountMenuItem(
                      icon: Icons.calendar_today_outlined,
                      title: AppStrings.submitLeave,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.more_time,
                      title: AppStrings.submitOvertime,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.description_outlined,
                      title: AppStrings.submitPayslip,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.payments_outlined,
                      title: AppStrings.reimbursement,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: Icons.logout,
                      title: AppStrings.logout,
                      onTap: () {
                        ref.read(authControllerProvider).logout().then((_) {
                          if (context.mounted) {
                            context.go('/login');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
