import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee_model.dart';
import '../repositories/employee_repository.dart';

import '../../../core/constants/app_strings.dart';

final currentEmployeeProvider = FutureProvider<EmployeeModel>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  return await repository.getCurrentEmployee().timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw Exception(AppStrings.errorConnection),
  );
});
