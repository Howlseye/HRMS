import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/models/activity_model.dart';

import '../repositories/attendance_repository.dart';

final attendanceHistoryProvider = FutureProvider.autoDispose<List<ActivityModel>>((ref) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  return repository.getAttendanceHistory();
});
