import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../models/notification_model.dart';

class InboxNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    return [
      NotificationModel(
        title: 'Persetujuan Karyawan Baru Disetujui',
        description: 'Persetujuan karyawan baru Afdal Ramdan sedang dalam Proses Persetujuan oleh CEO.',
        time: '2 Jam lalu',
        status: AppStrings.statusApproved,
        isRead: false,
      ),
      NotificationModel(
        title: 'Persetujuan Karyawan Baru Ditolak',
        description: 'Persetujuan karyawan baru Daman Huri telah Ditolak oleh CEO.',
        time: '12 Nov',
        status: AppStrings.statusRejected,
        isRead: false,
      ),
      NotificationModel(
        title: 'Kontrak Karyawan Perlu Peninjauan',
        description: 'Kontrak Livia Gouse tersisa 90 hari lagi, segera lakukan peninjauan terhadap karyawan sebelum 20 Nov 2024.',
        time: '11 Nov',
        status: AppStrings.statusWaiting,
        isRead: true,
      ),
      NotificationModel(
        title: 'Kontrak Karyawan Perlu Peninjauan',
        description: 'Kontrak Hanna Donin tersisa 90 hari lagi, segera lakukan peninjauan terhadap karyawan sebelum 20 Nov 2024.',
        time: '9 Nov',
        status: AppStrings.statusWaiting,
        isRead: true,
      ),
      NotificationModel(
        title: 'Pengajuan Karyawan Baru Diterima',
        description: 'Pengajuan karyawan baru Sari Anisa berhasil disetujui oleh Manajer HR.',
        time: '15 Nov',
        status: AppStrings.statusApproved,
        isRead: true,
      ),
    ];
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }
}

final inboxProvider = NotifierProvider<InboxNotifier, List<NotificationModel>>(() {
  return InboxNotifier();
});
