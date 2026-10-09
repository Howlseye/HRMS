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

  Future<ShiftModel?> getCurrentShift({String? defaultShift}) async {
    try {
      final listResponse = await _dio.get(ApiEndpoints.getShift);
      final listData = listResponse.data['data'] as List?;
      
      Map<String, dynamic>? activeShift;
      
      if (listData != null && listData.isNotEmpty) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        for (final item in listData) {
          final startDateStr = item['start_date'] as String?;
          final endDateStr = item['end_date'] as String?;
          
          DateTime? startDate;
          DateTime? endDate;
          
          if (startDateStr != null && startDateStr.isNotEmpty) {
            startDate = DateTime.tryParse(startDateStr);
          }
          if (endDateStr != null && endDateStr.isNotEmpty) {
            endDate = DateTime.tryParse(endDateStr);
          }
          
          if (startDate != null) {
            if (endDate != null) {
              if (!today.isBefore(startDate) && !today.isAfter(endDate)) {
                activeShift = item as Map<String, dynamic>;
                break;
              }
            } else {
              if (!today.isBefore(startDate)) {
                activeShift = item as Map<String, dynamic>;
                break;
              }
            }
          }
        }
      }
      
      if (activeShift == null && defaultShift != null && defaultShift.isNotEmpty) {
        activeShift = {
          'shift_type': defaultShift,
          'shift_location': null,
        };
      }

      if (activeShift == null) {
        return null;
      }
      
      final shiftType = activeShift['shift_type'] as String;
      final shiftLocationStr = activeShift['shift_location'] as String?;

      final detailResponse = await _dio.get(
        ApiEndpoints.getShiftDetail.replaceFirst('{shift}', shiftType),
      );
      
      final detailData = detailResponse.data['data'];
      var shiftModel = ShiftModel.fromJson(detailData);

      String? locationToFetch = shiftLocationStr;
      if (locationToFetch == null || locationToFetch.isEmpty) {
        locationToFetch = detailData['custom_default_shift_location'] as String?;
      }

      if (locationToFetch != null && locationToFetch.isNotEmpty) {
        try {
          final locResponse = await _dio.get(
            ApiEndpoints.getShiftLocation.replaceFirst('{location}', locationToFetch),
          );
          final locData = locResponse.data['data'];
          
          if (locData != null) {
            shiftModel = shiftModel.copyWith(
              latitude: (locData['custom_latitude'] as num?)?.toDouble(),
              longitude: (locData['custom_longitude'] as num?)?.toDouble(),
              checkinRadius: (locData['custom_checkin_radius'] as num?)?.toDouble(),
              locationName: locData['location_name'] as String?,
            );
          }
        } catch (_) {
          shiftModel = shiftModel.copyWith();
        }
      }

      return shiftModel;
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) {
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
    } on DioException catch (e) { if (e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    } catch (e) { if (e is DioException && e.error != null) { throw Exception(e.error.toString()); } else { throw Exception(AppStrings.errorServerSide); }
    }
  }
}
