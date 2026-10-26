import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../../../core/widgets/month_year_filter_bar.dart';
import '../widgets/leave_card.dart';

import '../models/leave_detail_args_model.dart';
import '../providers/leave_provider.dart';
import '../providers/leave_allocation_provider.dart';
import '../../../core/widgets/status_filter_bottom_sheet.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_popup.dart';
import '../../../core/widgets/custom_loading_indicator.dart';

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> {
  DateTime _filterDate = DateTime.now();
  String _selectedStatus = AppStrings.allStatus;

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatusFilterBottomSheet(
          initialStatus: _selectedStatus,
          onStatusSelected: (status) {
            setState(() {
              _selectedStatus = status;
            });
          },
        );
      },
    );
  }

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
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      leaveAllocationProvider,
      (_, state) {
        if (!state.isLoading && state.hasValue) {
          final data = state.value;
          if (data != null) {
            String? title;
            String? desc;
            
            if (data.leaveAllocation.isEmpty) {
              title = AppStrings.noLeaveAllocationTitle;
              desc = AppStrings.noLeaveAllocationDesc;
            } else if (data.leaveApprover == null || data.leaveApprover!.isEmpty) {
              title = AppStrings.noLeaveApproverTitle;
              desc = AppStrings.noLeaveApproverDesc;
            }

            if (title != null && desc != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AppPopup(
                  svgAsset: AppAssets.popupCancelIcon,
                  title: title!,
                  description: desc!,
                  primaryButtonText: AppStrings.backToHome,
                  secondaryButtonText: '',
                  onPrimaryPressed: () {
                    context.pop();
                    context.go('/main');
                  },
                  onSecondaryPressed: () {},
                ),
              );
            }
          }
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.leaveTitle,
        titleStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        iconColor: AppColors.textPrimary,
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
                        child: CustomLoadingIndicator(width: 24, height: 24),
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
              MonthYearFilterBar(
                selectedDate: _filterDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _filterDate = newDate;
                  });
                },
                showFilterIcon: true,
                onFilterTapped: _showFilterBottomSheet,
                allowFutureMonths: true,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ref.watch(leaveProvider).when(
                  data: (leaves) {
                    final filteredLeaves = leaves.where((leave) {
                      try {
                        final lDate = DateTime.parse(leave.fromDate);
                        if (lDate.month != _filterDate.month || lDate.year != _filterDate.year) {
                          return false;
                        }
                      } catch (_) {}

                      if (_selectedStatus == AppStrings.allStatus) return true;
                      
                      final uiStatus = _mapStatus(leave.status);
                      if (_selectedStatus == AppStrings.statusWaitingEnum && uiStatus == LeaveStatus.waiting) return true;
                      if (_selectedStatus == AppStrings.statusApprovedEnum && uiStatus == LeaveStatus.approved) return true;
                      if (_selectedStatus == AppStrings.statusRejectedEnum && uiStatus == LeaveStatus.rejected) return true;
                      if (_selectedStatus == 'Dibatalkan' && uiStatus == LeaveStatus.cancelled) return true;
                      
                      return false;
                    }).toList();

                    if (filteredLeaves.isEmpty) {
                      return CustomRefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(leaveAllocationProvider);
                          ref.invalidate(leaveProvider);
                          await ref.read(leaveProvider.future);
                        },
                        child: LayoutBuilder(
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
                                      AppAssets.emptyData,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      AppStrings.noLeaveRequest,
                                      style: AppTextStyles.titleBold.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppStrings.noLeaveRequestSub,
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
                        ),
                      );
                    }

                    return CustomRefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(leaveAllocationProvider);
                        ref.invalidate(leaveProvider);
                        await ref.read(leaveProvider.future);
                      },
                      child: ListView.builder(
                        itemCount: filteredLeaves.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final leave = filteredLeaves[index];
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

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: LeaveCard(
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
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CustomLoadingIndicator(),
                  ),
                  error: (error, stack) => AppErrorWidget(
                    errorMessage: error.toString().replaceAll('Exception: ', ''),
                    onRetry: () {
                      ref.invalidate(leaveAllocationProvider);
                      ref.invalidate(leaveProvider);
                    },
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
