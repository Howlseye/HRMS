import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shift_model.dart';
import '../repositories/shift_repository.dart';

import '../../employee/providers/current_employee_provider.dart';
import '../../../core/constants/app_strings.dart';

final currentShiftProvider = FutureProvider<ShiftModel?>((ref) async {
  final repository = ref.watch(shiftRepositoryProvider);
  final employee = await ref.watch(currentEmployeeProvider.future);
  
  return await repository.getCurrentShift(defaultShift: employee.defaultShift).timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw Exception(AppStrings.errorConnection),
  );
});
