import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance_log_entry.dart';

final attendanceLogProvider = Provider<List<AttendanceLogEntry>>((ref) {
  return [
    AttendanceLogEntry(
      id: '1',
      date: '03 Agu',
      fullDate: 'Sen, 03 Agu 2026',
      workingHours: 'Jam Kerja 08:00 – 17:00',
      checkIn: '07:50',
      checkOut: '17:10',
    ),
    AttendanceLogEntry(
      id: '2',
      date: '04 Agu',
      fullDate: 'Sel, 04 Agu 2026',
      workingHours: 'Jam Kerja 08:00 – 17:00',
      checkIn: '08:37',
      checkOut: '17:15',
      isLate: true,
      lateReason: 'Ban motor saya bocor, sehingga perlu pergi ke bengkel untuk tambal ban dulu',
    ),
    AttendanceLogEntry(
      id: '3',
      date: '05 Agu',
      fullDate: 'Rab, 05 Agu 2026',
      workingHours: 'Jam Kerja 08:00 – 17:00',
      checkIn: '07:50',
      checkOut: '17:10',
    ),
    AttendanceLogEntry(
      id: '4',
      date: '06 Agu',
      fullDate: 'Kam, 06 Agu 2026',
      workingHours: 'Jam Kerja 08:00 – 17:00',
      checkIn: '07:50',
      checkOut: '15:03',
      isEarlyOut: true,
      earlyOutReason: 'Ada urusan keluarga mendadak',
    ),
    AttendanceLogEntry(
      id: '5',
      date: '07 Agu',
      fullDate: 'Jum, 07 Agu 2026',
      workingHours: 'Jam Kerja 08:00 – 17:00',
      checkIn: '07:55',
      checkOut: '17:00',
    ),
  ];
});
