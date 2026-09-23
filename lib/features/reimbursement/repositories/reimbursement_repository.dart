import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/constants/app_strings.dart';
import '../../employee/models/employee_model.dart';
import '../models/benefit_type_model.dart';
import '../models/reimbursement_model.dart';

final reimbursementRepositoryProvider = Provider<ReimbursementRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ReimbursementRepository(dio);
});

class ReimbursementRepository {
  final Dio _dio;

  ReimbursementRepository(this._dio);

  Future<List<BenefitTypeModel>> getBenefitTypes() async {
    try {
      final response = await _dio.get(ApiEndpoints.getBenefitType);
      
      final data = response.data['data'] as List?;
      if (data == null) return [];

      return data.map((json) => BenefitTypeModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }

  Future<List<ReimbursementModel>> getReimbursements() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getReimbursements,
        queryParameters: {
          'order_by': 'creation desc',
        },
      );
      
      final data = response.data['data'] as List?;
      if (data == null) return [];

      List<ReimbursementModel> reimbursements = [];
      
      final detailFutures = data.map((item) async {
        final name = item['name'] as String;
        try {
          final detailResponse = await _dio.get(
            ApiEndpoints.getReimbursementsDetail.replaceAll('{id}', name),
          );
          final detailData = detailResponse.data['data'];
          if (detailData != null) {
            return ReimbursementModel.fromJson(detailData);
          }
        } catch (e) {
          debugPrint('Failed to load detail for $name: $e');
        }
        return null;
      });

      final results = await Future.wait(detailFutures);
      for (final res in results) {
        if (res != null) {
          reimbursements.add(res);
        }
      }

      return reimbursements;
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }
  Future<void> cancelReimbursement(String id) async {
    try {
      await _dio.delete(
        ApiEndpoints.getReimbursementsDetail.replaceAll('{id}', id),
      );
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }
  Future<void> submitReimbursement(List<ReimbursementItemModel> items, EmployeeModel employee) async {
    try {
      final List<Map<String, dynamic>> expenses = [];
      int totalAmount = 0;

      for (final item in items) {
        final parsedAmount = AppCurrencyFormatter.parseToDouble(item.amount).toInt();
        String expenseDate = item.transactionDate;
        try {
          final date = DateFormat('d MMM yyyy').parse(item.transactionDate);
          expenseDate = DateFormat('yyyy-MM-dd').format(date);
        } catch (_) {}

        String customTransferProof = '';
        if (item.attachmentPath != null && item.attachmentPath!.isNotEmpty) {
          if (!item.attachmentPath!.startsWith('/private') && !item.attachmentPath!.startsWith('/files')) {
            final filename = item.attachmentPath!.split(RegExp(r'[\\/]')).last;
            final formData = FormData.fromMap({
              'file': await MultipartFile.fromFile(item.attachmentPath!, filename: filename),
              'is_private': 1,
            });

            final uploadRes = await _dio.post(ApiEndpoints.uploadFile, data: formData);
            if (uploadRes.data != null && uploadRes.data['message'] != null) {
              customTransferProof = uploadRes.data['message']['file_url'] ?? '';
            }
          } else {
            customTransferProof = item.attachmentPath!;
          }
        }

        expenses.add({
          'expense_date': expenseDate,
          'expense_type': item.name,
          'amount': parsedAmount,
          'sanctioned_amount': parsedAmount,
          'base_amount': parsedAmount,
          'base_sanctioned_amount': parsedAmount,
          'description': item.description,
          'custom_transfer_proof': customTransferProof,
          'custom_status_approval': 'Pending',
        });
        totalAmount += parsedAmount;
      }

      final postingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await _dio.post(
        ApiEndpoints.getReimbursements,
        data: {
          'naming_series': 'HR-EXP-.YYYY.-',
          'posting_date': postingDate,
          'employee': employee.id,
          'expense_approver': employee.expenseApprover ?? '',
          'company': employee.company ?? '',
          'currency': 'IDR',
          'exchange_rate': 1,
          'expenses': expenses,
          'total_claimed_amount': totalAmount,
          'total_sanctioned_amount': totalAmount,
          'grand_total': totalAmount,
          'base_total_sanctioned_amount': totalAmount,
          'base_grand_total': totalAmount,
          'base_total_claimed_amount': totalAmount,
        },
      );
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }

  Future<String> downloadAttachment(String url, String fileName) async {
    try {
      Directory? downloadDir;
      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
        if (!await downloadDir.exists()) {
          downloadDir = await getExternalStorageDirectory();
        }
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }
      
      final fallbackDir = await getTemporaryDirectory();
      final finalDir = downloadDir ?? fallbackDir;
      
      final savePath = '${finalDir.path}/$fileName';
      
      await _dio.download(
        Uri.encodeFull(url), 
        savePath,
      );
      
      return savePath;
    } catch (e) {
      debugPrint('Error download: $e');
      throw Exception(AppStrings.downloadFailed);
    }
  }
}
