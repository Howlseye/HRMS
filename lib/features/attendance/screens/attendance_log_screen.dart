import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/attendance_log_provider.dart';

class AttendanceLogScreen extends ConsumerWidget {
  const AttendanceLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(attendanceLogProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.attendanceLog,
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: AppColors.bgWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => _showMonthPicker(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, color: AppColors.iconNavy, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.filterMonth,
                          style: AppTextStyles.title.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.expand_more, color: AppColors.textSecondary, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: AppStrings.statCuti,
                            value: '0',
                            icon: Icons.person_remove_outlined,
                            iconColor: AppColors.textDanger,
                            iconBgColor: AppColors.menuBgPink,
                            hasBorderRight: true,
                            hasBorderBottom: true,
                          ),
                        ),
                        Expanded(
                          child: _buildStatCard(
                            title: AppStrings.statTerlambat,
                            value: '1',
                            icon: Icons.access_time_outlined,
                            iconColor: AppColors.iconYellow,
                            iconBgColor: AppColors.menuBgOrangeLight,
                            hasBorderRight: false,
                            hasBorderBottom: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: AppStrings.statPulangAwal,
                            value: '0',
                            icon: Icons.directions_run,
                            iconColor: AppColors.iconPurple,
                            iconBgColor: AppColors.menuBgLavender,
                            hasBorderRight: true,
                            hasBorderBottom: false,
                          ),
                        ),
                        Expanded(
                          child: _buildStatCard(
                            title: AppStrings.statTidakAbsen,
                            value: '0',
                            icon: Icons.desktop_access_disabled,
                            iconColor: AppColors.iconOrange,
                            iconBgColor: AppColors.menuBgPeach,
                            hasBorderRight: false,
                            hasBorderBottom: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.attendanceList,
                    style: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.borderLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      AppStrings.totalDays,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ...logs.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Material(
                      color: AppColors.bgWhite,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => context.push('/attendance-detail', extra: entry),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                          child: Row(
                            children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.date,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.checkIn,
                            style: AppTextStyles.bodyMediumExtraBold.copyWith(
                              color: entry.isLate ? AppColors.textDanger : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.checkOut,
                            style: AppTextStyles.bodyMediumExtraBold.copyWith(
                              color: entry.isEarlyOut ? AppColors.textDanger : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.iconNavy,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required bool hasBorderRight,
    required bool hasBorderBottom,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          right: hasBorderRight ? const BorderSide(color: AppColors.borderLight) : BorderSide.none,
          bottom: hasBorderBottom ? const BorderSide(color: AppColors.borderLight) : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.textSuccess,
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 484,
          decoration: const BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dragHandle,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Text('Aug', style: AppTextStyles.bodyMediumSemiBold.copyWith(color: AppColors.textPrimary)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary, size: 18),
                        ],
                      ),
                    ),
                    Text('2026', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.38))),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderLight),
              Expanded(
                child: ListView.builder(
                  itemCount: AppStrings.monthNames.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => context.pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        child: Text(
                          AppStrings.monthNames[index],
                          style: AppTextStyles.title.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
