enum ReimbursementStatus { waiting, approved, rejected }

class ReimbursementItemModel {
  final String name;
  final String amount;
  final String? approvedAmount;
  final String transactionDate;
  final String description;
  final String attachmentName;
  final String? notes;

  const ReimbursementItemModel({
    required this.name,
    required this.amount,
    this.approvedAmount,
    required this.transactionDate,
    required this.description,
    required this.attachmentName,
    this.notes,
  });

  factory ReimbursementItemModel.fromJson(Map<String, dynamic> json) {
    return ReimbursementItemModel(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
      approvedAmount: json['approvedAmount'],
      transactionDate: json['transaction_date'] ?? '',
      description: json['description'] ?? '',
      attachmentName: json['attachment_name'] ?? '',
      notes: json['notes'],
    );
  }
}

class ReimbursementModel {
  final String id;
  final String title;
  final ReimbursementStatus status;
  final String date;
  final List<ReimbursementItemModel> items;
  final String? rejectReason;

  const ReimbursementModel({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
    required this.items,
    this.rejectReason,
  });

  factory ReimbursementModel.fromJson(Map<String, dynamic> json) {
    return ReimbursementModel(
      id: json['name'] ?? '',
      title: json['name'] ?? '',
      status: _parseStatus(json['status']),
      date: json['posting_date'] ?? '',
      items: [], // This will be parsed from a child table when implemented
    );
  }

  static ReimbursementStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return ReimbursementStatus.approved;
      case 'rejected':
        return ReimbursementStatus.rejected;
      default:
        return ReimbursementStatus.waiting;
    }
  }
}
