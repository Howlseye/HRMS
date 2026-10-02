import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reimbursement_model.dart';
import '../repositories/reimbursement_repository.dart';

final benefitTypeProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(reimbursementRepositoryProvider);
  final benefits = await repository.getBenefitTypes();
  return benefits.map((b) => b.name).toList();
});

final reimbursementProvider = FutureProvider.autoDispose<List<ReimbursementModel>>((ref) async {
  final repository = ref.watch(reimbursementRepositoryProvider);
  return await repository.getReimbursements();
});
