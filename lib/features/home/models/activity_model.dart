import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ActivityModel {
  final IconData icon;
  final String title;
  final String date;
  final String time;
  final Color? iconColor;
  final Color? iconBgColor;
  final bool isTimeWarning;

  ActivityModel({
    required this.icon,
    required this.title,
    required this.date,
    required this.time,
    this.iconColor,
    this.iconBgColor,
    this.isTimeWarning = false,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    final logType = json['log_type'] as String? ?? 'IN';
    final timeStr = json['time'] as String? ?? '';
    final shiftStartStr = json['shift_start'] as String?;
    final shiftEndStr = json['shift_end'] as String?;
    
    DateTime? timeObj;
    if (timeStr.isNotEmpty) {
      timeObj = DateTime.tryParse(timeStr);
    }
    
    DateTime? shiftStartObj;
    if (shiftStartStr != null && shiftStartStr.isNotEmpty) {
      shiftStartObj = DateTime.tryParse(shiftStartStr);
    }
    
    DateTime? shiftEndObj;
    if (shiftEndStr != null && shiftEndStr.isNotEmpty) {
      shiftEndObj = DateTime.tryParse(shiftEndStr);
    }

    bool isWarning = false;
    if (timeObj != null) {
      if (logType == 'IN' && shiftStartObj != null) {
        isWarning = timeObj.isAfter(shiftStartObj);
      } else if (logType == 'OUT' && shiftEndObj != null) {
        isWarning = timeObj.isBefore(shiftEndObj);
      }
    }

    String formattedDate = '';
    String formattedTime = '';
    if (timeObj != null) {
      final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      final dayName = dayNames[timeObj.weekday - 1];
      final monthName = AppStrings.monthNames[timeObj.month - 1];
      formattedDate = '$dayName, ${timeObj.day.toString().padLeft(2, '0')} $monthName ${timeObj.year}';
      formattedTime = '${timeObj.hour.toString().padLeft(2, '0')}:${timeObj.minute.toString().padLeft(2, '0')}';
    }

    return ActivityModel(
      icon: logType == 'IN' ? Icons.login : Icons.logout,
      title: logType == 'IN' ? AppStrings.checkIn : AppStrings.checkOut,
      date: formattedDate,
      time: formattedTime,
      iconColor: logType == 'IN' ? null : AppColors.iconGray,
      iconBgColor: logType == 'IN' ? null : AppColors.menuBgGray,
      isTimeWarning: isWarning,
    );
  }
}

