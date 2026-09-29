import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

class StatusFilterBottomSheet extends StatefulWidget {
  final String initialStatus;
  final ValueChanged<String> onStatusSelected;
  final List<String>? options;

  const StatusFilterBottomSheet({
    super.key,
    required this.initialStatus,
    required this.onStatusSelected,
    this.options,
  });

  @override
  State<StatusFilterBottomSheet> createState() => _StatusFilterBottomSheetState();
}

class _StatusFilterBottomSheetState extends State<StatusFilterBottomSheet> {
  late String _selectedStatus;

  late List<String> _statuses;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _statuses = widget.options ?? [
      AppStrings.allStatus,
      AppStrings.statusWaitingEnum,
      AppStrings.statusApprovedEnum,
      AppStrings.statusRejectedEnum,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.iconGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppStrings.filterBy,
                style: AppTextStyles.bodyMediumBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ..._statuses.map((status) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedStatus = status;
                  });
                  widget.onStatusSelected(status);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Radio<String>(
                          value: status,
                          groupValue: _selectedStatus,
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                _selectedStatus = value;
                              });
                              widget.onStatusSelected(value);
                              Navigator.pop(context);
                            }
                          },
                          activeColor: AppColors.primaryBlueStart,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
