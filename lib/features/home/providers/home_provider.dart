import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../models/activity_model.dart';
import '../models/announcement_model.dart';

final activityProvider = Provider<List<ActivityModel>>((ref) {
  return [
    ActivityModel(
      icon: Icons.login,
      title: 'Check In',
      date: 'June 24, 2024',
      time: '07:59',
    ),
    ActivityModel(
      icon: Icons.logout,
      title: 'Check Out',
      date: 'June 24, 2024',
      time: '17:05',
      iconColor: AppColors.iconGray,
      iconBgColor: AppColors.menuBgGray,
    ),
  ];
});

final announcementProvider = Provider<List<AnnouncementModel>>((ref) {
  return [
    AnnouncementModel(
      title: 'Gathering Padepokan 79 — Sept',
      description: 'Pendaftaran tim untuk gathering tahunan dibuka sampai 10 Sep.',
      date: '31 Agu 2026',
    ),
    AnnouncementModel(
      title: 'Slip gaji Agustus sudah tersedia',
      description: 'Cek menu Slip Gaji untuk rincian tunjangan dan potongan.',
      date: '31 Agu 2026',
    ),
    AnnouncementModel(
      title: 'Kebijakan baru clock in hybrid',
      description: 'Clock in di luar radius kantor wajib mengisi catatan.',
      date: '31 Agu 2026',
    ),
  ];
});
