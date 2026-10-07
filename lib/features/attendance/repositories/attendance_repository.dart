import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../home/models/activity_model.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AttendanceRepository(dio);
});

class AttendanceRepository {
  final Dio _dio;

  AttendanceRepository(this._dio);

  Future<void> submitPresence(String employeeId, String logType, String time, {String? lateReason, String? earlyReason, String? wfhReason, double? latitude, double? longitude}) async {
    try {
      final Map<String, dynamic> data = {
        "employee": employeeId,
        "time": time,
        "log_type": logType,
        "skip_auto_attendance": 0,
      };

      if (lateReason != null && lateReason.isNotEmpty) {
        data["custom_late_reason"] = lateReason;
      }
      if (earlyReason != null && earlyReason.isNotEmpty) {
        data["custom_early_reason"] = earlyReason;
      }
      if (wfhReason != null && wfhReason.isNotEmpty) {
        data["custom_wfh_reason"] = wfhReason;
      }
      if (latitude != null) {
        data["custom_latitude"] = latitude;
      }
      if (longitude != null) {
        data["custom_longitude"] = longitude;
      }

      final response = await _dio.post(
        ApiEndpoints.getPresence,
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(AppStrings.errorServerSide);
      }
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) { if (e is DioException && e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    }
  }

  Future<List<ActivityModel>> getAttendanceHistory() async {
    try {
      final response = await _dio.get(ApiEndpoints.presence);
      final listData = response.data['data'] as List?;
      
      if (listData == null || listData.isEmpty) {
        return [];
      }

      return listData.map((json) => ActivityModel.fromJson(json)).toList();
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) { if (e is DioException && e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceLogs(int year, int month) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);
      
      final startDateStr = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      final endDateStr = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      final String filters = '[["attendance_date", "between", ["$startDateStr", "$endDateStr"]]]';
      
      final response = await _dio.get(
        ApiEndpoints.getAttendance,
        queryParameters: {
          'filters': filters,
        },
      );
      
      final listData = response.data['data'] as List?;
      if (listData == null || listData.isEmpty) {
        return [];
      }
      
      return List<Map<String, dynamic>>.from(listData);
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) { if (e is DioException && e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    }
  }

  Future<List<Map<String, dynamic>>> getCheckinsByDate(String date) async {
    try {
      final startDateStr = "$date 00:00:00";
      final endDateStr = "$date 23:59:59";
      
      String endpoint = ApiEndpoints.getActivity;
      endpoint = endpoint.replaceAll('{start_date}', '"$startDateStr"');
      endpoint = endpoint.replaceAll('{end_date}', '"$endDateStr"');

      final response = await _dio.get(endpoint);
      final listData = response.data['data'] as List?;
      
      if (listData == null || listData.isEmpty) {
        return [];
      }
      
      return List<Map<String, dynamic>>.from(listData);
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) { if (e is DioException && e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    }
  }
}
