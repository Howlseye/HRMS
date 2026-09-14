import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/models/activity_model.dart';

final attendanceHistoryProvider = Provider<List<ActivityModel>>((ref) {
  return [
    ActivityModel(
      icon: Icons.logout,
      title: 'Check Out',
      date: '31 Nov, 2026',
      time: '17:05',
      iconColor: AppColors.iconGray,
      iconBgColor: AppColors.menuBgGray,
    ),
    ActivityModel(
      icon: Icons.login,
      title: 'Check In',
      date: '31 Nov, 2026',
      time: '07:59',
    ),
    ActivityModel(
      icon: Icons.logout,
      title: 'Check Out',
      date: '30 Nov, 2026',
      time: '17:38',
      iconColor: AppColors.iconGray,
      iconBgColor: AppColors.menuBgGray,
    ),
    ActivityModel(
      icon: Icons.login,
      title: 'Check In',
      date: '30 Nov, 2026',
      time: '08:37',
      isTimeWarning: true,
    ),
    ActivityModel(
      icon: Icons.logout,
      title: 'Check Out',
      date: '29 Nov, 2026',
      time: '17:10',
      iconColor: AppColors.iconGray,
      iconBgColor: AppColors.menuBgGray,
    ),
    ActivityModel(
      icon: Icons.login,
      title: 'Check In',
      date: '29 Nov, 2026',
      time: '07:50',
    ),
  ];
});
