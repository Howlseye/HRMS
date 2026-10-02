import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';
import '../../features/attendance/providers/current_shift_provider.dart';
import '../../features/attendance/providers/presence_provider.dart';
import 'custom_loading_indicator.dart';
import '../../features/employee/providers/current_employee_provider.dart';
import '../../features/home/providers/home_provider.dart';
import '../../features/attendance/widgets/presence_note_bottom_sheet.dart';
import 'app_snackbar.dart';

class AttendanceCard extends ConsumerWidget {
  final bool transparentBackground;

  const AttendanceCard({
    super.key,
    this.transparentBackground = false,
  });

  String _formatTime(String time) {
    if (time.isEmpty) return '';
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return time;
  }

  bool _isLate(String startTime) {
    if (startTime.isEmpty) return false;
    final now = DateTime.now();
    final parts = startTime.split(':');
    if (parts.length >= 2) {
      final shiftStart = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      return now.isAfter(shiftStart);
    }
    return false;
  }

  bool _isEarly(String endTime) {
    if (endTime.isEmpty) return false;
    final now = DateTime.now();
    final parts = endTime.split(':');
    if (parts.length >= 2) {
      final shiftEnd = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      return now.isBefore(shiftEnd);
    }
    return false;
  }

  String _formatDate() {
    final now = DateTime.now();
    final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final dayName = dayNames[now.weekday - 1];
    final monthName = AppStrings.monthNames[now.month - 1];
    return '$dayName, ${now.day.toString().padLeft(2, '0')} $monthName ${now.year}';
  }

  String _getCurrentTimeForApi() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
           '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  String _calculateTimeDifferenceForSubmit(String scheduledTime, bool isCheckIn) {
    final now = DateTime.now();
    final parts = scheduledTime.split(':');
    if (parts.length >= 2) {
      final scheduledHour = int.tryParse(parts[0]) ?? 0;
      final scheduledMinute = int.tryParse(parts[1]) ?? 0;
      
      final scheduledDateTime = DateTime(now.year, now.month, now.day, scheduledHour, scheduledMinute);
      
      Duration diff;
      if (isCheckIn) {
        diff = now.difference(scheduledDateTime);
      } else {
        diff = scheduledDateTime.difference(now);
      }
      
      if (diff.isNegative) {
        diff = diff.abs();
      }
      
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      
      return "$hours:$minutes";
    }
    return "00:00";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftAsync = ref.watch(currentShiftProvider);
    final presenceState = ref.watch(presenceProvider);
    final employeeAsync = ref.watch(currentEmployeeProvider);
    final isPresenceLoading = presenceState.isLoading;

    final activityAsync = ref.watch(activityProvider);
    String statusText = AppStrings.notCheckedIn;
    bool isCheckedIn = false;
    bool isCheckedOut = false;
    
    activityAsync.whenData((activities) {
      if (activities.isNotEmpty) {
        isCheckedOut = activities.any((a) => a.title == AppStrings.checkOut);
        isCheckedIn = activities.any((a) => a.title == AppStrings.checkIn);
        
        if (isCheckedOut) {
          statusText = AppStrings.alreadyCheckedOut;
        } else if (isCheckedIn) {
          statusText = AppStrings.alreadyCheckedIn;
        }
      }
    });

    return Container(
      margin: transparentBackground ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24.0),
      padding: transparentBackground ? const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0) : const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: transparentBackground
          ? null
          : BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlueStart,
            AppColors.primaryBlueEnd,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: shiftAsync.when(
        loading: () => const Center(
          child: CustomLoadingIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text(
            AppStrings.noShiftData,
            style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.textWhite),
          ),
        ),
        data: (shift) {
          if (shift == null) {
            return Center(
              child: Text(
                AppStrings.noShiftData,
                style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.textWhite),
              ),
            );
          }
          final startTime = _formatTime(shift.startTime);
          final endTime = _formatTime(shift.endTime);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _formatDate(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppStrings.workHoursPrefix}$startTime – $endTime',
                style: AppTextStyles.headingExtraBold.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.login,
                      label: AppStrings.checkIn,
                      isLoading: isPresenceLoading,
                      onPressed: isCheckedIn ? null : () async {
                        final employee = employeeAsync.value;
                        if (employee == null) return;
                        
                        Future<void> submit(String notes) async {
                          try {
                            await ref.read(presenceProvider.notifier).submitPresence(
                              employee.id, 
                              'IN', 
                              _getCurrentTimeForApi(),
                              lateReason: notes,
                            );
                            if (notes.isNotEmpty && context.mounted) {
                              Navigator.of(context).pop();
                            }
                            if (context.mounted) {
                              context.push('/attendance-success', extra: {
                                'isCheckIn': true,
                                'date': _formatDate(),
                                'timeRange': '${AppStrings.workHoursPrefix}$startTime – $endTime',
                                'alertMessage': notes.isNotEmpty ? _calculateTimeDifferenceForSubmit(startTime, true) : null,
                              });
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackbar.show(
                                context,
                                message: e.toString().replaceAll('Exception: ', ''),
                                type: SnackbarType.error,
                              );
                            }
                            if (notes.isNotEmpty) {
                              rethrow;
                            }
                          }
                        }

                        if (_isLate(shift.startTime)) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppColors.transparent,
                            builder: (context) => PresenceNoteBottomSheet(
                              isCheckIn: true,
                              timeLimit: startTime,
                              onSubmit: submit,
                            ),
                          );
                        } else {
                          await submit('');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.logout,
                      label: AppStrings.checkOut,
                      isLoading: isPresenceLoading,
                      onPressed: (!isCheckedIn || isCheckedOut) ? null : () async {
                        final employee = employeeAsync.value;
                        if (employee == null) return;
                        
                        Future<void> submit(String notes) async {
                          try {
                            await ref.read(presenceProvider.notifier).submitPresence(
                              employee.id, 
                              'OUT', 
                              _getCurrentTimeForApi(),
                              earlyReason: notes,
                            );
                            if (notes.isNotEmpty && context.mounted) {
                              Navigator.of(context).pop();
                            }
                            if (context.mounted) {
                              context.push('/attendance-success', extra: {
                                'isCheckIn': false,
                                'date': _formatDate(),
                                'timeRange': '${AppStrings.workHoursPrefix}$startTime – $endTime',
                                'alertMessage': notes.isNotEmpty ? _calculateTimeDifferenceForSubmit(endTime, false) : null,
                              });
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackbar.show(
                                context,
                                message: e.toString().replaceAll('Exception: ', ''),
                                type: SnackbarType.error,
                              );
                            }
                            if (notes.isNotEmpty) {
                              rethrow;
                            }
                          }
                        }

                        if (_isEarly(shift.endTime)) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppColors.transparent,
                            builder: (context) => PresenceNoteBottomSheet(
                              isCheckIn: false,
                              timeLimit: endTime,
                              onSubmit: submit,
                            ),
                          );
                        } else {
                          await submit('');
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.textWhite,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isLoading,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.bgWhite,
        disabledBackgroundColor: AppColors.buttonDisabled,
        foregroundColor: AppColors.primaryBlueStart,
        disabledForegroundColor: AppColors.iconDisabled,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      icon: isLoading 
          ? const SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(
                strokeWidth: 2, 
                color: AppColors.iconDisabled,
              ),
            )
          : Icon(icon, size: 20),
      label: Text(
        label,
        style: AppTextStyles.headingSmall,
      ),
    );
  }
}
