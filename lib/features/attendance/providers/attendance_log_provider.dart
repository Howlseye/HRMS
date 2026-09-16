import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance_log_entry.dart';
import '../models/shift_model.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/shift_repository.dart';

class AttendanceFilterDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void updateDate(DateTime newDate) {
    state = newDate;
  }
}

final attendanceFilterDateProvider = NotifierProvider<AttendanceFilterDateNotifier, DateTime>(() {
  return AttendanceFilterDateNotifier();
});

final attendanceLogProvider = FutureProvider<List<AttendanceLogEntry>>((ref) async {
  final filterDate = ref.watch(attendanceFilterDateProvider);
  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  final shiftRepo = ref.watch(shiftRepositoryProvider);

  final rawLogs = await attendanceRepo.getAttendanceLogs(filterDate.year, filterDate.month);
  
  if (rawLogs.isEmpty) return [];

  final Map<String, ShiftModel?> shiftCache = {};

  final List<AttendanceLogEntry> entries = [];
  
  for (var log in rawLogs) {
    final shiftName = log['shift'] as String?;
    
    if (shiftName != null && !shiftCache.containsKey(shiftName)) {
      try {
        final shiftDetail = await shiftRepo.getShiftDetail(shiftName);
        shiftCache[shiftName] = shiftDetail;
      } catch (e) {
        shiftCache[shiftName] = null;
      }
    }

    final shift = shiftName != null ? shiftCache[shiftName] : null;
    
    String workingHours = '-';
    if (shift != null && shift.startTime.isNotEmpty && shift.endTime.isNotEmpty) {
      final start = shift.startTime.length >= 5 ? shift.startTime.substring(0, 5) : shift.startTime;
      final end = shift.endTime.length >= 5 ? shift.endTime.substring(0, 5) : shift.endTime;
      workingHours = 'Jam Kerja $start – $end';
    }
    
    String inTime = '-';
    if (log['in_time'] != null) {
      final inTimeStr = log['in_time'].toString();
      if (inTimeStr.length >= 16) {
        inTime = inTimeStr.substring(11, 16);
      }
    }
    
    String outTime = '-';
    if (log['out_time'] != null) {
      final outTimeStr = log['out_time'].toString();
      if (outTimeStr.length >= 16) {
        outTime = outTimeStr.substring(11, 16);
      }
    }
    
    final dateStr = log['attendance_date'].toString();
    DateTime? dateObj = DateTime.tryParse(dateStr);
    
    String dateLabel = '-';
    String fullDateLabel = '-';
    
    if (dateObj != null) {
      final monthShort = _getMonthShort(dateObj.month);
      final day = dateObj.day.toString().padLeft(2, '0');
      dateLabel = '$day $monthShort';
      
      final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      final dayName = days[dateObj.weekday - 1];
      fullDateLabel = '$dayName, $day $monthShort ${dateObj.year}';
    }

    entries.add(AttendanceLogEntry(
      id: log['name'] ?? '',
      date: dateLabel,
      rawDate: dateStr,
      fullDate: fullDateLabel,
      workingHours: workingHours,
      checkIn: inTime,
      checkOut: outTime,
      isLate: (log['late_entry'] ?? 0) == 1,
      isEarlyOut: (log['early_exit'] ?? 0) == 1,
      lateReason: null,
      earlyOutReason: null,
    ));
  }

  return entries;
});

final attendanceDetailProvider = FutureProvider.family<Map<String, String?>, AttendanceLogEntry>((ref, entry) async {
  if (!entry.isLate && !entry.isEarlyOut) {
    return {
      'lateReason': null,
      'earlyOutReason': null,
    };
  }

  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  final checkins = await attendanceRepo.getCheckinsByDate(entry.rawDate);

  String? lateReason;
  String? earlyOutReason;

  for (var checkin in checkins) {
    final logType = checkin['log_type'] as String?;
    if (logType == 'IN') {
      lateReason = checkin['custom_late_reason'] as String?;
    } else if (logType == 'OUT') {
      earlyOutReason = checkin['custom_early_reason'] as String?;
    }
  }

  return {
    'lateReason': lateReason,
    'earlyOutReason': earlyOutReason,
  };
});

String _getMonthShort(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  return months[month - 1];
}
