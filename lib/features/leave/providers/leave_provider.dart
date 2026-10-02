import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/leave_model.dart';
import '../repositories/leave_repository.dart';

final leaveProvider = FutureProvider.autoDispose<List<LeaveModel>>((ref) async {
  final leaveRepo = ref.watch(leaveRepositoryProvider);
  return await leaveRepo.getLeaves();
});
