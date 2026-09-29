import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/info_dialog.dart';
import '../../../core/widgets/month_year_filter_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../providers/reimbursement_provider.dart';
import '../widgets/reimbursement_card.dart';
import '../../../core/widgets/status_filter_bottom_sheet.dart';
import '../models/reimbursement_model.dart';

class ReimbursementScreen extends ConsumerStatefulWidget {
  const ReimbursementScreen({super.key});

  @override
  ConsumerState<ReimbursementScreen> createState() => _ReimbursementScreenState();
}

class _ReimbursementScreenState extends ConsumerState<ReimbursementScreen> {
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
          options: const [
            AppStrings.allStatus,
            AppStrings.reimburseStatusDraft,
            AppStrings.reimburseStatusSubmitted,
            AppStrings.reimburseStatusCancelled,
            AppStrings.reimburseStatusPaid,
            AppStrings.reimburseStatusUnpaid,
            AppStrings.reimburseStatusRejected,
          ],
          onStatusSelected: (status) {
            setState(() {
              _selectedStatus = status;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(
        title: AppStrings.reimbursementTitle,
        onBackPressed: () => context.go('/main'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            MonthYearFilterBar(
              selectedDate: _filterDate,
              onDateChanged: (newDate) {
                setState(() {
                  _filterDate = newDate;
                });
              },
              showFilterIcon: true,
              onFilterTapped: _showFilterBottomSheet,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ref.watch(reimbursementProvider).when(
                    data: (reimbursements) {
                      final filteredReimbursements = reimbursements.where((r) {
                        try {
                          final rDate = DateTime.parse(r.date);
                          if (rDate.month != _filterDate.month || rDate.year != _filterDate.year) {
                            return false;
                          }
                        } catch (_) {}

                        if (_selectedStatus == AppStrings.allStatus) return true;
                        if (_selectedStatus == AppStrings.reimburseStatusDraft && r.status == ReimbursementStatus.draft) return true;
                        if (_selectedStatus == AppStrings.reimburseStatusSubmitted && r.status == ReimbursementStatus.submitted) return true;
                        if (_selectedStatus == AppStrings.reimburseStatusCancelled && r.status == ReimbursementStatus.cancelled) return true;
                        if (_selectedStatus == AppStrings.reimburseStatusPaid && r.status == ReimbursementStatus.paid) return true;
                        if (_selectedStatus == AppStrings.reimburseStatusUnpaid && r.status == ReimbursementStatus.unpaid) return true;
                        if (_selectedStatus == AppStrings.reimburseStatusRejected && r.status == ReimbursementStatus.rejected) return true;
                        return false;
                      }).toList();

                      if (filteredReimbursements.isEmpty) {
                        return CustomRefreshIndicator(
                          onRefresh: () async {
                            final _ = await ref.refresh(reimbursementProvider.future);
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
                                        'assets/icons/empty_data.svg',
                                        width: 100,
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        AppStrings.noReimbursementRequest,
                                        style: AppTextStyles.titleBold.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppStrings.noReimbursementRequestSub,
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
                          final _ = await ref.refresh(reimbursementProvider.future);
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredReimbursements.length,
                          itemBuilder: (context, index) {
                            final data = filteredReimbursements[index];
                            return ReimbursementCard(
                              title: data.title,
                              status: data.status,
                              date: data.date,
                              items: data.items,
                              onTap: () {
                                context.push('/reimbursement/detail', extra: data);
                              },
                            );
                          },
                        ),
                      );
                  },
                  loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => InfoDialog(
              title: AppStrings.infoPengajuanTitle,
              description: AppStrings.infoPengajuanDesc,
              cancelText: AppStrings.batal,
              continueText: AppStrings.lanjutkan,
              onCancel: () => Navigator.of(context).pop(),
              onContinue: () {
                Navigator.of(context).pop();
                context.push('/reimbursement/new');
              },
            ),
          );
        },
        backgroundColor: AppColors.primaryBlueStart,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
    );
  }
}
