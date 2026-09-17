import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../employee/providers/current_employee_provider.dart';
import '../models/leave_allocation_model.dart';
import '../repositories/leave_repository.dart';

final leaveAllocationProvider = FutureProvider<LeaveDetailsResponse>((ref) async {
  final employee = await ref.watch(currentEmployeeProvider.future);
  final repository = ref.watch(leaveRepositoryProvider);
  
  final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  
  return await repository.getLeaveAllocations(employee.id, todayDate);
});
