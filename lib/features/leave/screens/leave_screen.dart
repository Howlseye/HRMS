import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../widgets/leave_card.dart';
import 'leave_detail_screen.dart';
import '../providers/leave_provider.dart';
import '../providers/leave_allocation_provider.dart';

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  LeaveStatus _mapStatus(String statusStr) {
    switch (statusStr) {
      case 'Open':
        return LeaveStatus.waiting;
      case 'Approved':
        return LeaveStatus.approved;
      case 'Rejected':
        return LeaveStatus.rejected;
      case 'Cancelled':
        return LeaveStatus.cancelled;
      default:
        return LeaveStatus.waiting;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
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
                    ref.watch(leaveAllocationProvider).when(
                      data: (response) {
                        final allocations = response.leaveAllocation;
                        final cutiTahunan = allocations['Cuti Tahunan'];
                        final remaining = cutiTahunan?.remainingLeaves ?? 0.0;
                        return Text(
                          '${remaining.toInt()} Hari',
                          style: AppTextStyles.titleSemiBold.copyWith(
                            color: AppColors.textWhite,
                          ),
                        );
                      },
                      loading: () => const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: AppColors.bgWhite, strokeWidth: 2),
                      ),
                      error: (err, stack) => Text(
                        AppStrings.none,
                        style: AppTextStyles.titleSemiBold.copyWith(
                          color: AppColors.textWhite,
                        ),
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
                              DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now()),
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
                child: ref.watch(leaveProvider).when(
                  data: (leaves) {
                    if (leaves.isEmpty) {
                      return CustomRefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(leaveAllocationProvider);
                          await ref.refresh(leaveProvider.future);
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: Text(
                                  AppStrings.noLeaveRequest,
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return CustomRefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(leaveAllocationProvider);
                        await ref.refresh(leaveProvider.future);
                      },
                      child: ListView.builder(
                        itemCount: leaves.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                        final leave = leaves[index];
                        final status = _mapStatus(leave.status);
                        
                        String statusDateStr = '-';
                        if (leave.postingDate.isNotEmpty) {
                          try {
                            final pDate = DateTime.parse(leave.postingDate);
                            statusDateStr = DateFormat('d MMM yyyy').format(pDate);
                          } catch (_) {}
                        }

                        String dateRangeStr = '-';
                        String startDateStr = '-';
                        if (leave.fromDate.isNotEmpty && leave.toDate.isNotEmpty) {
                          try {
                            final fDate = DateTime.parse(leave.fromDate);
                            final tDate = DateTime.parse(leave.toDate);
                            startDateStr = DateFormat('d MMM yyyy').format(fDate);
                            dateRangeStr = '${DateFormat('d MMM').format(fDate)} - ${DateFormat('d MMM yyyy').format(tDate)}';
                          } catch (_) {}
                        }

                        return LeaveCard(
                          title: leave.name.isNotEmpty ? leave.name : AppStrings.none,
                          status: status,
                          statusDate: statusDateStr,
                          leaveType: leave.leaveType.isNotEmpty ? leave.leaveType : AppStrings.none,
                          dateRange: dateRangeStr,
                          onTap: () {
                            context.push(
                              '/leave/detail',
                              extra: LeaveDetailArgs(
                                title: leave.name.isNotEmpty ? leave.name : AppStrings.none,
                                status: status,
                                submissionDate: statusDateStr,
                                leaveType: leave.leaveType.isNotEmpty ? leave.leaveType : AppStrings.none,
                                startDate: startDateStr,
                                reason: leave.description.isNotEmpty ? leave.description : AppStrings.noReason,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryBlueStart),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      AppStrings.errorLoadData,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDanger),
                    ),
                  ),
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
