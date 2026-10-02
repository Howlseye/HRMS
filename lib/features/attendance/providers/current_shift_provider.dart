import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shift_model.dart';
import '../repositories/shift_repository.dart';

import '../../../core/constants/app_strings.dart';

final currentShiftProvider = FutureProvider<ShiftModel?>((ref) async {
  final repository = ref.watch(shiftRepositoryProvider);
  return await repository.getCurrentShift().timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw Exception(AppStrings.errorConnection),
  );
});
