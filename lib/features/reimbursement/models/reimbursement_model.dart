import 'package:intl/intl.dart';

enum ReimbursementStatus { waiting, approved, rejected }

class ReimbursementItemModel {
  final String name;
  final String amount;
  final String? approvedAmount;
  final String transactionDate;
  final String description;
  final String attachmentName;
  final String? attachmentPath;
  final String? notes;

  const ReimbursementItemModel({
    required this.name,
    required this.amount,
    this.approvedAmount,
    required this.transactionDate,
    required this.description,
    required this.attachmentName,
    this.attachmentPath,
    this.notes,
  });

  factory ReimbursementItemModel.fromJson(Map<String, dynamic> json) {
    return ReimbursementItemModel(
      name: json['expense_type']?.toString() ?? json['name']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      approvedAmount: json['sanctioned_amount']?.toString(),
      transactionDate: json['expense_date']?.toString() ?? json['transaction_date']?.toString() ?? '',
      description: _stripHtml(json['description']?.toString() ?? ''),
      attachmentName: json['custom_transfer_proof']?.toString() ?? json['attachment_name']?.toString() ?? '',
      attachmentPath: json['custom_transfer_proof']?.toString() ?? json['attachment_name']?.toString(),
      notes: json['notes']?.toString(),
    );
  }

  static String _stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
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
    final expenses = json['expenses'] as List?;
    final itemsList = expenses != null 
        ? expenses.map((e) => ReimbursementItemModel.fromJson(e as Map<String, dynamic>)).toList()
        : <ReimbursementItemModel>[];

    String formattedDate = json['posting_date'] ?? '';
    if (formattedDate.isNotEmpty) {
      try {
        final pDate = DateTime.parse(formattedDate);
        formattedDate = DateFormat('d MMM yyyy').format(pDate);
      } catch (_) {}
    }

    return ReimbursementModel(
      id: json['name'] ?? '',
      title: json['name'] ?? '',
      status: _parseStatus(json['approval_status'] ?? json['status']),
      date: formattedDate,
      items: itemsList,
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
