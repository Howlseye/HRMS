import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/draft_reimbursement_detail_model.dart';

final draftDetailProvider = Provider<DraftReimbursementDetail>((ref) => DraftReimbursementDetail());
