import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../models/leave_model.dart';
import '../models/leave_allocation_model.dart';

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LeaveRepository(dio);
});

class LeaveRepository {
  final Dio _dio;

  LeaveRepository(this._dio);

  Future<List<LeaveModel>> getLeaves() async {
    try {
      final response = await _dio.get(ApiEndpoints.getLeave);
      final listData = response.data['data'] as List?;
      
      if (listData == null || listData.isEmpty) {
        return [];
      }

      return listData.map((json) => LeaveModel.fromJson(json)).toList();
    } on DioException catch (_) {
      throw Exception(AppStrings.errorServerSide);
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }

  Future<void> cancelLeave(String name) async {
    try {
      await _dio.delete(
        ApiEndpoints.getLeaveDetail.replaceAll('{id}', name),
      );
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }

  Future<LeaveDetailsResponse> getLeaveAllocations(String employeeId, String date) async {
    try {
      final endpoint = ApiEndpoints.getLeaveAllocations
          .replaceAll('{employee_id}', employeeId)
          .replaceAll('{today_date}', date);
      
      final response = await _dio.get(endpoint);
      
      final message = response.data['message'];
      if (message != null) {
        final Map<String, LeaveAllocationDetail> allocationResult = {};
        if (message['leave_allocation'] != null) {
          final allocationMap = message['leave_allocation'] as Map<String, dynamic>;
          allocationMap.forEach((key, value) {
            allocationResult[key] = LeaveAllocationDetail.fromJson(value);
          });
        }
        return LeaveDetailsResponse(
          leaveAllocation: allocationResult,
          leaveApprover: message['leave_approver'] as String?,
        );
      }
      return LeaveDetailsResponse(leaveAllocation: {});
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }

  Future<void> createLeave({
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String description,
    required String leaveApprover,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.createLeave,
        data: {
          "status": "Open",
          "leave_type": leaveType,
          "from_date": fromDate,
          "to_date": toDate,
          "description": description,
          "leave_approver": leaveApprover,
        },
      );
    } catch (e) {
      throw Exception(AppStrings.errorServerSide);
    }
  }
}
