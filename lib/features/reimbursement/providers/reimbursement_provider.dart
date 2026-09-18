import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../models/reimbursement_model.dart';

final reimbursementProvider = FutureProvider<List<ReimbursementModel>>((ref) async {
  return [];
});
