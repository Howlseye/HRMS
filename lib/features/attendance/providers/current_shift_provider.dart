import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shift_model.dart';
import '../repositories/shift_repository.dart';

final currentShiftProvider = FutureProvider<ShiftModel>((ref) async {
  final repository = ref.watch(shiftRepositoryProvider);
  return await repository.getCurrentShift();
});
