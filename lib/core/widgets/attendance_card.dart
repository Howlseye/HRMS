import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_assets.dart';
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
import 'app_popup.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceCard extends ConsumerStatefulWidget {
  final bool transparentBackground;

  const AttendanceCard({
    super.key,
    this.transparentBackground = false,
  });

  @override
  ConsumerState<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends ConsumerState<AttendanceCard> {
  String? _activeLoadingType;

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


  String _formatDate() {
    final now = DateTime.now();
    final dayNames = AppStrings.shortDayNames;
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
  Widget build(BuildContext context) {
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
      margin: widget.transparentBackground ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24.0),
      padding: widget.transparentBackground ? const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0) : const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: widget.transparentBackground
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
                      isLoading: isPresenceLoading && _activeLoadingType == 'IN',
                      onPressed: isCheckedIn ? null : () async {
                        final employee = employeeAsync.value;
                        if (employee == null) return;
                        
                        setState(() { _activeLoadingType = 'IN'; });
                        
                        Future<void> processSubmit(String notes, String wfhNotes, Position position) async {
                          try {
                            await ref.read(presenceProvider.notifier).submitPresence(
                              employee.id, 
                              'IN', 
                              _getCurrentTimeForApi(),
                              position,
                              lateReason: notes.isNotEmpty ? notes : null,
                              wfhReason: wfhNotes.isNotEmpty ? wfhNotes : null,
                            );
                            if (context.mounted) {
                              if (notes.isNotEmpty || wfhNotes.isNotEmpty) {
                                Navigator.of(context).pop();
                              }
                              context.push('/attendance-success', extra: {
                                'isCheckIn': true,
                                'date': _formatDate(),
                                'timeRange': '${AppStrings.workHoursPrefix}$startTime – $endTime',
                                'alertMessage': notes.isNotEmpty ? _calculateTimeDifferenceForSubmit(startTime, true) : null,
                              });
                            }
                          } catch (e) {
                            if ((notes.isNotEmpty || wfhNotes.isNotEmpty) && context.mounted) {
                              Navigator.of(context).pop();
                            }
                            if (context.mounted) {
                              AppSnackbar.show(
                                context,
                                message: e.toString().replaceAll('Exception: ', ''),
                                type: SnackbarType.error,
                              );
                            }
                          }
                        }

                        try {
                          final checkResult = await ref.read(presenceProvider.notifier).checkLocation(
                            shift.latitude, 
                            shift.longitude, 
                            shift.checkinRadius
                          );
                          
                          final isLate = _isLate(shift.startTime);

                          if (checkResult.isOutOfRadius) {
                            if (!context.mounted) return;
                            showDialog(
                              context: context,
                              builder: (ctx) => AppPopup(
                                svgAsset: AppAssets.popupInfoIcon,
                                iconColor: AppColors.primaryBlueStart,
                                title: AppStrings.wfhConfirmationTitle,
                                description: AppStrings.wfhConfirmationMessage,
                                primaryButtonText: AppStrings.lanjutkan,
                                secondaryButtonText: AppStrings.batal,
                                onSecondaryPressed: () => Navigator.pop(ctx),
                                onPrimaryPressed: () {
                                  Navigator.pop(ctx);
                                  if (!context.mounted) return;
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: AppColors.transparent,
                                    builder: (context) => PresenceNoteBottomSheet(
                                      isCheckIn: true,
                                      isLate: isLate,
                                      isOutOfRadius: true,
                                      timeLimit: startTime,
                                      onSubmit: (notes, wfhNotes) => processSubmit(notes, wfhNotes, checkResult.position),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (isLate) {
                            if (!context.mounted) return;
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppColors.transparent,
                              builder: (context) => PresenceNoteBottomSheet(
                                isCheckIn: true,
                                isLate: true,
                                isOutOfRadius: false,
                                timeLimit: startTime,
                                onSubmit: (notes, wfhNotes) => processSubmit(notes, wfhNotes, checkResult.position),
                              ),
                            );
                          } else {
                            await processSubmit('', '', checkResult.position);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            AppSnackbar.show(
                              context,
                              message: e.toString().replaceAll('Exception: ', ''),
                              type: SnackbarType.error,
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() { _activeLoadingType = null; });
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.logout,
                      label: AppStrings.checkOut,
                      isLoading: isPresenceLoading && _activeLoadingType == 'OUT',
                      onPressed: (!isCheckedIn || isCheckedOut) ? null : () {
                        context.push('/add-log-book');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: isCheckedOut 
                      ? AppColors.menuBgGreen 
                      : AppColors.menuBgYellow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCheckedOut ? Icons.check_circle : Icons.access_time_filled,
                      color: isCheckedOut 
                          ? AppColors.textSuccess 
                          : AppColors.iconYellow,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: AppTextStyles.bodySmallMedium.copyWith(
                        color: isCheckedOut 
                            ? AppColors.textSuccess 
                            : AppColors.iconYellow,
                      ),
                    ),
                  ],
                ),
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
