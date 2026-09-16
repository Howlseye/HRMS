import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../models/shift_model.dart';

final shiftRepositoryProvider = Provider<ShiftRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ShiftRepository(dio);
});

class ShiftRepository {
  final Dio _dio;

  ShiftRepository(this._dio);

  Future<ShiftModel> getCurrentShift() async {
    try {
      final listResponse = await _dio.get(ApiEndpoints.getShift);
      final listData = listResponse.data['data'] as List?;
      
      if (listData == null || listData.isEmpty) {
        throw Exception(AppStrings.errorDataNotFound);
      }

      final shiftType = listData.first['shift_type'] as String;
      
      final detailResponse = await _dio.get(
        ApiEndpoints.getShiftDetail.replaceFirst('{shift}', shiftType),
      );
      
      final detailData = detailResponse.data['data'];

      return ShiftModel.fromJson(detailData);
    } on DioException catch (_) {
      throw Exception(AppStrings.errorServerSide);
    } catch (e) {
      if (e.toString().contains(AppStrings.errorDataNotFound)) {
        rethrow;
      }
      throw Exception(AppStrings.errorServerSide);
    }
  }

  Future<ShiftModel> getShiftDetail(String shiftType) async {
    try {
      final detailResponse = await _dio.get(
        ApiEndpoints.getShiftDetail.replaceFirst('{shift}', shiftType),
      );
      
      final detailData = detailResponse.data['data'];
      return ShiftModel.fromJson(detailData);
    } on DioException catch (_) {
      throw Exception(AppStrings.errorServerSide);
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }
}
