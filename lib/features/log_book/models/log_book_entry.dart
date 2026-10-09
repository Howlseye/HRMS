class LogBookEntry {
  final String date;
  final String status;
  final String checkInTime;
  final String checkOutTime;
  final String activities;
  final String detail;
  final String constraints;
  final String? rejectReason;

  LogBookEntry({
    required this.date,
    required this.status,
    required this.checkInTime,
    required this.checkOutTime,
    required this.activities,
    required this.detail,
    required this.constraints,
    this.rejectReason,
  });
}
