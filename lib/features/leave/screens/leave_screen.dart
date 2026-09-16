import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/leave_card.dart';
import 'leave_detail_screen.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.leaveTitle,
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueStart,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.flight,
                          color: AppColors.textWhite,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.remainingYearlyLeave,
                          style: AppTextStyles.title.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppStrings.dummyLeaveDays,
                      style: AppTextStyles.titleSemiBold.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        border: Border.all(color: AppColors.borderLight),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.iconDisabled,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppStrings.dummyLeaveFilter,
                              style: AppTextStyles.title.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.expand_more,
                            color: AppColors.iconDisabled,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.bgWhite,
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    LeaveCard(
                      title: AppStrings.dummyLeaveTitle1,
                      status: LeaveStatus.waiting,
                      statusDate: AppStrings.dummyLeaveDate1,
                      leaveType: AppStrings.dummyLeaveTypeYearly,
                      dateRange: AppStrings.dummyLeaveRange1,
                      onTap: () {
                        context.push(
                          '/leave/detail',
                          extra: LeaveDetailArgs(
                            title: AppStrings.dummyLeaveTitle1,
                            status: LeaveStatus.waiting,
                            submissionDate: AppStrings.dummyLeaveDate1,
                            leaveType: AppStrings.dummyLeaveTypeYearly,
                            startDate: AppStrings.dummyLeaveStartDate1,
                            reason: AppStrings.dummyLeaveReason,
                          ),
                        );
                      },
                    ),
                    LeaveCard(
                      title: AppStrings.dummyLeaveTitle2,
                      status: LeaveStatus.rejected,
                      statusDate: AppStrings.dummyLeaveDate2,
                      leaveType: AppStrings.dummyLeaveTypeMarriage,
                      dateRange: AppStrings.dummyLeaveRange2,
                      onTap: () {
                        context.push(
                          '/leave/detail',
                          extra: LeaveDetailArgs(
                            title: AppStrings.dummyLeaveTitle2,
                            status: LeaveStatus.rejected,
                            submissionDate: AppStrings.dummyLeaveDate2,
                            leaveType: AppStrings.dummyLeaveTypeMarriage,
                            startDate: AppStrings.dummyLeaveStartDate2,
                            reason: AppStrings.dummyLeaveReason,
                            rejectReason: AppStrings.dummyLeaveRejectReason,
                          ),
                        );
                      },
                    ),
                    LeaveCard(
                      title: AppStrings.dummyLeaveTitle3,
                      status: LeaveStatus.approved,
                      statusDate: AppStrings.dummyLeaveDate3,
                      leaveType: AppStrings.dummyLeaveTypeYearly,
                      dateRange: AppStrings.dummyLeaveRange3,
                      onTap: () {
                        context.push(
                          '/leave/detail',
                          extra: LeaveDetailArgs(
                            title: AppStrings.dummyLeaveTitle3,
                            status: LeaveStatus.approved,
                            submissionDate: AppStrings.dummyLeaveDate3,
                            leaveType: AppStrings.dummyLeaveTypeYearly,
                            startDate: AppStrings.dummyLeaveStartDate3,
                            reason: AppStrings.dummyLeaveReason,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/leave/new');
        },
        backgroundColor: AppColors.primaryBlueStart,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: AppColors.textWhite,
        ),
      ),
    );
  }
}
