import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class PresenceNoteBottomSheet extends ConsumerStatefulWidget {
  final bool isCheckIn;
  final String timeLimit;
  final Future<void> Function(String notes) onSubmit;

  const PresenceNoteBottomSheet({
    super.key,
    required this.isCheckIn,
    required this.timeLimit,
    required this.onSubmit,
  });

  @override
  ConsumerState<PresenceNoteBottomSheet> createState() => _PresenceNoteBottomSheetState();
}

class _PresenceNoteBottomSheetState extends ConsumerState<PresenceNoteBottomSheet> {
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    final notes = _notesController.text.trim();
    if (notes.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSubmit(notes);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _calculateTimeDifference() {
    final now = DateTime.now();
    final parts = widget.timeLimit.split(':');
    if (parts.length >= 2) {
      final scheduledHour = int.tryParse(parts[0]) ?? 0;
      final scheduledMinute = int.tryParse(parts[1]) ?? 0;
      
      final scheduledDateTime = DateTime(now.year, now.month, now.day, scheduledHour, scheduledMinute);
      
      Duration diff;
      if (widget.isCheckIn) {
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
    final timeDiff = _calculateTimeDifference();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 36,
                alignment: Alignment.center,
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dragHandle,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.menuBgPink,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.textDanger,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: widget.isCheckIn
                              ? AppStrings.noteLateCheckInPrefix
                              : AppStrings.noteEarlyCheckOutPrefix,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textDanger,
                            height: 20 / 14,
                          ),
                          children: [
                            TextSpan(
                              text: timeDiff,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textDanger,
                                fontWeight: FontWeight.w700,
                                height: 20 / 14,
                              ),
                            ),
                            TextSpan(
                              text: widget.isCheckIn
                                  ? AppStrings.noteLateCheckInSuffix
                                  : AppStrings.noteEarlyCheckOutSuffix,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textDanger,
                                height: 20 / 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: widget.isCheckIn ? AppStrings.reasonLate : AppStrings.reasonEarlyOut,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 20 / 14,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textDanger,
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 126,
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.isCheckIn ? AppStrings.noteLateCheckInHint : AppStrings.noteEarlyCheckOutHint,
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.iconDisabled,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: AppColors.borderDivider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: AppColors.borderDivider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: AppColors.primaryBlueStart),
                        ),
                        filled: true,
                        fillColor: AppColors.bgWhite,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _notesController.text.trim().isEmpty || _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlueStart,
                    disabledBackgroundColor: AppColors.buttonDisabled,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.bgWhite,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          widget.isCheckIn ? AppStrings.sendCheckIn : AppStrings.sendCheckOut,
                          style: AppTextStyles.buttonText.copyWith(
                            color: _notesController.text.trim().isEmpty
                                ? AppColors.iconDisabled
                                : AppColors.textWhite,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
