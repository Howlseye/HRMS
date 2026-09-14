class AttendanceLogEntry {
  final String id;
  final String date;
  final String fullDate;
  final String workingHours;
  final String checkIn;
  final String checkOut;
  final bool isLate;
  final bool isEarlyOut;
  final String? lateReason;
  final String? earlyOutReason;

  AttendanceLogEntry({
    required this.id,
    required this.date,
    required this.fullDate,
    required this.workingHours,
    required this.checkIn,
    required this.checkOut,
    this.isLate = false,
    this.isEarlyOut = false,
    this.lateReason,
    this.earlyOutReason,
  });
}
