import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../models/announcement_model.dart';

import '../repositories/activity_repository.dart';

final activityProvider = FutureProvider<List<ActivityModel>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return await repository.getTodayActivities();
});
final announcementProvider = Provider<List<AnnouncementModel>>((ref) {
  return [];
});
