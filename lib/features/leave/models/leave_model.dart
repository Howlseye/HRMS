class LeaveModel {
  final String status;
  final String name;
  final String postingDate;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final double totalLeaveDays;
  final String description;

  LeaveModel({
    required this.status,
    required this.name,
    required this.postingDate,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.totalLeaveDays,
    required this.description,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      status: json['status'] ?? '',
      name: json['name'] ?? '',
      postingDate: json['posting_date'] ?? '',
      leaveType: json['leave_type'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      totalLeaveDays: (json['total_leave_days'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }
}
