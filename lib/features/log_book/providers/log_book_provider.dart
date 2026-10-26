import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/log_book_template_model.dart';
import '../models/timesheet_approval_model.dart';
import '../models/timesheet_detail_model.dart';
import '../repositories/log_book_repository.dart';

class LogBookData {
  final LogBookTemplateResponse template;
  final TimesheetDetailResponse? timesheetDetail;
  final List<TimesheetApprovalItem> approvals;

  LogBookData({
    required this.template,
    this.timesheetDetail,
    this.approvals = const [],
  });
}

final logBookDataProvider = FutureProvider.autoDispose.family<LogBookData, String>((ref, date) async {
  final repository = ref.watch(logBookRepositoryProvider);
  final templateResponse = await repository.getTemplate(date);
  
  TimesheetDetailResponse? timesheetResponse;
  List<TimesheetApprovalItem> approvals = [];
  final tsName = templateResponse.timesheet.name;
  
  if (tsName.isNotEmpty) {
    try {
      timesheetResponse = await repository.getLog(tsName);
    } catch (e) {
      timesheetResponse = null;
    }

    try {
      approvals = await repository.getLogStatus(tsName);
    } catch (e) {
      approvals = [];
    }
  }

  return LogBookData(
    template: templateResponse,
    timesheetDetail: timesheetResponse,
    approvals: approvals,
  );
});
