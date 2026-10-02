import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../models/activity_model.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ActivityRepository(dio);
});

class ActivityRepository {
  final Dio _dio;

  ActivityRepository(this._dio);

  Future<List<ActivityModel>> getTodayActivities() async {
    try {
      final now = DateTime.now();
      final startDateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00';
      final endDateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 23:59:59';
      
      final url = ApiEndpoints.getActivity
          .replaceFirst('{start_date}', '"$startDateStr"')
          .replaceFirst('{end_date}', '"$endDateStr"');

      final response = await _dio.get(url);
      final listData = response.data['data'] as List?;
      
      if (listData == null || listData.isEmpty) {
        return [];
      }

      return listData.map((json) => ActivityModel.fromJson(json)).toList();
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) { if (e is DioException && e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    }
  }
}
