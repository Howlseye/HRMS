import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../providers/employee_provider.dart';
import '../providers/employee_filter_provider.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_filter_bottom_sheet.dart';

class EmployeeScreen extends ConsumerWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(employeeProvider);
    final filterState = ref.watch(employeeFilterProvider);
    final isFilterActive = filterState.selectedLocations.isNotEmpty || filterState.selectedRoles.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${AppStrings.menuEmployee} ',
                      style: AppTextStyles.headingExtraBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: '(${employees.length})',
                          style: AppTextStyles.headingExtraBold.copyWith(
                            color: AppColors.primaryBlueStart,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.transparent,
                        builder: (context) => const EmployeeFilterBottomSheet(),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: isFilterActive
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.menuBgBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.filter_alt,
                              color: AppColors.primaryBlueStart,
                              size: 20,
                            ),
                          )
                        : const Icon(
                            Icons.filter_alt_outlined,
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).updateQuery(value);
                },
                decoration: InputDecoration(
                  hintText: AppStrings.searchEmployeeHint,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.iconDisabled,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.iconDisabled,
                  ),
                  filled: true,
                  fillColor: AppColors.bgWhite,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryBlueStart),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CustomRefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(employeeProvider);
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: employees.isEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) => ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Container(
                              height: constraints.maxHeight,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/empty_data.svg',
                                    width: 120,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    AppStrings.noEmployeeData,
                                    style: AppTextStyles.titleBold.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppStrings.noEmployeeDataDesc,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24.0),
                        itemCount: employees.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return EmployeeCard(
                            employee: employee,
                            onTap: () {
                              context.push('/employee-detail', extra: employee);
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
