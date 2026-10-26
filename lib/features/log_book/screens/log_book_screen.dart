import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../widgets/log_book_admin_view.dart';
import '../widgets/log_book_employee_view.dart';

class LogBookScreen extends ConsumerStatefulWidget {
  const LogBookScreen({super.key});

  @override
  ConsumerState<LogBookScreen> createState() => _LogBookScreenState();
}

class _LogBookScreenState extends ConsumerState<LogBookScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(currentEmployeeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.logBookTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
        leading: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: employeeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (employee) {
            final isAdmin = employee.role.toLowerCase() == 'hr manager';

            if (!isAdmin) {
              return const LogBookEmployeeView();
            }

            return Column(
              children: [
                Container(
                  color: AppColors.bgLight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedTabIndex == 0 ? AppColors.primaryBlueStart : AppColors.transparent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.tabApproval,
                              style: AppTextStyles.bodyMediumBold.copyWith(
                                color: _selectedTabIndex == 0 ? AppColors.primaryBlueStart : AppColors.iconDisabled,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedTabIndex == 1 ? AppColors.primaryBlueStart : AppColors.transparent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.tabMyLog,
                              style: AppTextStyles.bodyMediumBold.copyWith(
                                color: _selectedTabIndex == 1 ? AppColors.primaryBlueStart : AppColors.iconDisabled,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _selectedTabIndex == 0 
                      ? const LogBookAdminView() 
                      : const LogBookEmployeeView(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
