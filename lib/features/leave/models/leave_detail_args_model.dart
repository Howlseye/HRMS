import '../widgets/leave_card.dart';

class LeaveDetailArgs {
  final String title;
  final LeaveStatus status;
  final String submissionDate;
  final String leaveType;
  final String startDate;
  final String reason;
  final String? rejectReason;

  LeaveDetailArgs({
    required this.title,
    required this.status,
    required this.submissionDate,
    required this.leaveType,
    required this.startDate,
    required this.reason,
    this.rejectReason,
  });
}
