import 'dart:io';

class DraftReimbursementDetail {
  String? selectedBenefit;
  DateTime? transactionDate;
  File? attachment;
  String? existingAttachmentName;
  String amount = '';
  String description = '';

  void clear() {
    selectedBenefit = null;
    transactionDate = null;
    attachment = null;
    existingAttachmentName = null;
    amount = '';
    description = '';
  }
}
