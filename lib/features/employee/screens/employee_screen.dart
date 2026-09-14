import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
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
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: '(${employees.length})',
                          style: AppTextStyles.headingExtraBold.copyWith(
                            color: AppColors.primaryBlueStart,
                            fontSize: 20,
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
                        backgroundColor: Colors.transparent,
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: employees.length,
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
          ],
        ),
      ),
    );
  }
}
