import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/account_menu_item.dart';
import '../../employee/providers/current_employee_provider.dart';

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
                  loading: () => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Lottie.asset(
                        'assets/lottie/loading.json',
                        width: 150,
                      ),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.errorServerSide,
                            style: AppTextStyles.headingSmall.copyWith(color: AppColors.textDanger),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.errorDataNotFound,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
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
        ),
      );
  }
}
