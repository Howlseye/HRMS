import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/shared_prefs_provider.dart';
import '../../auth/providers/auth_session_provider.dart';
import '../models/employee_model.dart';

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final session = ref.watch(authSessionProvider);
  return EmployeeRepository(dio, prefs, session);
});

class EmployeeRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  final Map<String, String> _session;

  EmployeeRepository(this._dio, this._prefs, this._session);

  Future<EmployeeModel> getCurrentEmployee() async {
    try {
      final listResponse = await _dio.get(ApiEndpoints.getEmployees);
      final listData = listResponse.data['data'] as List?;
      
      if (listData == null || listData.isEmpty) {
        throw Exception(AppStrings.errorDataNotFound);
      }

      final employeeId = listData.first['name'] as String;
      
      final detailResponse = await _dio.get(
        ApiEndpoints.getEmployeeDetail.replaceFirst('{id}', employeeId),
      );
      
      final detailData = detailResponse.data['data'];
      final avatarAsset = _session['user_image'] ?? _prefs.getString('user_image');

      return EmployeeModel.fromJson(
        detailData,
        avatarAsset: avatarAsset,
      );
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) {
      if (e.toString().contains(AppStrings.errorDataNotFound)) {
        rethrow;
      }
      throw Exception(AppStrings.errorServerSide);
    }
  }
}
