import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../home/providers/home_provider.dart';
import '../repositories/attendance_repository.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/location_utils.dart';

class LocationCheckResult {
  final Position position;
  final bool isOutOfRadius;
  LocationCheckResult(this.position, this.isOutOfRadius);
}

final presenceProvider = AsyncNotifierProvider<PresenceNotifier, void>(() {
  return PresenceNotifier();
});

class PresenceNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<LocationCheckResult> checkLocation(
    double? shiftLatitude, 
    double? shiftLongitude, 
    double? checkinRadius,
  ) async {
    state = const AsyncValue.loading();
    try {
      if (shiftLatitude == null || shiftLongitude == null || checkinRadius == null) {
        throw Exception(AppStrings.errorLocationDataNotFound);
      }

      final position = await LocationUtils.getCurrentPosition();

      final distance = LocationUtils.calculateDistance(
        position.latitude, 
        position.longitude, 
        shiftLatitude, 
        shiftLongitude
      );

      bool isOutOfRadius = distance > checkinRadius;
      
      state = const AsyncValue.data(null);
      return LocationCheckResult(position, isOutOfRadius);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> submitPresence(
    String employeeId, 
    String logType, 
    String time,
    Position position, {
    String? lateReason, 
    String? earlyReason, 
    String? wfhReason,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(attendanceRepositoryProvider);
      await repository.submitPresence(
        employeeId, 
        logType, 
        time, 
        lateReason: lateReason, 
        earlyReason: earlyReason,
        wfhReason: wfhReason, 
        latitude: position.latitude, 
        longitude: position.longitude
      );
      ref.invalidate(activityProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
