class TimesheetApprovalItem {
  final String name;
  final String date;
  final double totalHours;
  final String status;

  TimesheetApprovalItem({
    required this.name,
    required this.date,
    required this.totalHours,
    required this.status,
  });

  factory TimesheetApprovalItem.fromJson(Map<String, dynamic> json) {
    return TimesheetApprovalItem(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      totalHours: (json['total_hours'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
    );
  }
}
