import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../models/log_book_template_model.dart';
import '../models/timesheet_approval_model.dart';
import '../models/timesheet_detail_model.dart';

final logBookRepositoryProvider = Provider<LogBookRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LogBookRepository(dio);
});

class LogBookRepository {
  final Dio _dio;

  LogBookRepository(this._dio);

  Future<LogBookTemplateResponse> getTemplate(String date) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getTemplate.replaceAll('{date}', date),
      );

      return LogBookTemplateResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.error != null) {
        throw Exception(e.error.toString());
      } else {
        throw Exception(AppStrings.errorServerSide);
      }
    }
  }

  Future<TimesheetDetailResponse> getLog(String id) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getLog.replaceAll('{id}', id),
      );

      return TimesheetDetailResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.error != null) {
        throw Exception(e.error.toString());
      } else {
        throw Exception(AppStrings.errorServerSide);
      }
    }
  }

  Future<List<TimesheetApprovalItem>> getLogStatus(String timesheetId) async {
    try {
      final endpoint = ApiEndpoints.getLogStatus.replaceAll('{timesheet}', '"$timesheetId"');
      final response = await _dio.get(endpoint);
      final data = response.data['data'] as List?;
      return data?.map((e) => TimesheetApprovalItem.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    } catch (e) {
      if (e is DioException && e.error != null) {
        throw Exception(e.error.toString());
      } else {
        throw Exception(AppStrings.errorServerSide);
      }
    }
  }
}
