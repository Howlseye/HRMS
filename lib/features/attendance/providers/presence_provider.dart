import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/home_provider.dart';
import '../repositories/attendance_repository.dart';

final presenceProvider = AsyncNotifierProvider<PresenceNotifier, void>(() {
  return PresenceNotifier();
});

class PresenceNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> submitPresence(String employeeId, String logType, String time, {String? lateReason, String? earlyReason}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(attendanceRepositoryProvider);
      await repository.submitPresence(employeeId, logType, time, lateReason: lateReason, earlyReason: earlyReason);
      ref.invalidate(activityProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
