import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';


import '../repositories/activity_repository.dart';

import '../../../core/constants/app_strings.dart';

final activityProvider = FutureProvider<List<ActivityModel>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return await repository.getTodayActivities().timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw Exception(AppStrings.errorConnection),
  );
});
