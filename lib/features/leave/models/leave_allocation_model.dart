class LeaveAllocationDetail {
  final double totalLeaves;
  final double expiredLeaves;
  final double leavesTaken;
  final double leavesPendingApproval;
  final double remainingLeaves;

  LeaveAllocationDetail({
    required this.totalLeaves,
    required this.expiredLeaves,
    required this.leavesTaken,
    required this.leavesPendingApproval,
    required this.remainingLeaves,
  });

  factory LeaveAllocationDetail.fromJson(Map<String, dynamic> json) {
    return LeaveAllocationDetail(
      totalLeaves: (json['total_leaves'] ?? 0).toDouble(),
      expiredLeaves: (json['expired_leaves'] ?? 0).toDouble(),
      leavesTaken: (json['leaves_taken'] ?? 0).toDouble(),
      leavesPendingApproval: (json['leaves_pending_approval'] ?? 0).toDouble(),
      remainingLeaves: (json['remaining_leaves'] ?? 0).toDouble(),
    );
  }
}

class LeaveDetailsResponse {
  final Map<String, LeaveAllocationDetail> leaveAllocation;
  final String? leaveApprover;

  LeaveDetailsResponse({
    required this.leaveAllocation,
    this.leaveApprover,
  });
}
