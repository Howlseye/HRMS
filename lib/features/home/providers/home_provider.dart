import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../models/announcement_model.dart';

import '../repositories/activity_repository.dart';

final activityProvider = FutureProvider<List<ActivityModel>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return await repository.getTodayActivities();
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
