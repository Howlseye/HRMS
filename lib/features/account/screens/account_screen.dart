import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/account_menu_item.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/custom_loading_indicator.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentEmployeeAsync = ref.watch(currentEmployeeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: CustomRefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentEmployeeProvider);
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                currentEmployeeAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: CustomLoadingIndicator(),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: AppErrorWidget(
                      errorMessage: error.toString().replaceAll('Exception: ', ''),
                      onRetry: () {
                        ref.invalidate(currentEmployeeProvider);
                      },
                    ),
                  ),
                  data: (employee) => ProfileCard(employee: employee),
                ),
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
                          onTap: () {
                            context.push('/attendance-log');
                          },
                        ),
                        AccountMenuItem(
                          icon: Icons.assignment_outlined,
                          title: AppStrings.logBook,
                          onTap: () {
                            context.push('/attendance-log');
                          },
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
        ),
      );
  }
}
