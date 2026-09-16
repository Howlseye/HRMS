import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee_model.dart';
import '../repositories/employee_repository.dart';

final currentEmployeeProvider = FutureProvider<EmployeeModel>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  return await repository.getCurrentEmployee();
});
