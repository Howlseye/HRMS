import 'dart:convert';

class TimesheetDetailResponse {
  final TimesheetData data;

  TimesheetDetailResponse({required this.data});

  factory TimesheetDetailResponse.fromJson(Map<String, dynamic> json) {
    return TimesheetDetailResponse(
      data: TimesheetData.fromJson(json['data'] ?? {}),
    );
  }
}

class TimesheetData {
  final String name;
  final String status;
  final List<TimeLog> timeLogs;

  TimesheetData({
    required this.name,
    required this.status,
    required this.timeLogs,
  });

  factory TimesheetData.fromJson(Map<String, dynamic> json) {
    return TimesheetData(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      timeLogs: (json['time_logs'] as List?)
              ?.map((e) => TimeLog.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TimeLog {
  final String name;
  final String fromTime;
  final String toTime;
  final double hours;
  final String customApprovalStatus;
  final String customTemplateData;

  TimeLog({
    required this.name,
    required this.fromTime,
    required this.toTime,
    required this.hours,
    required this.customApprovalStatus,
    required this.customTemplateData,
  });

  factory TimeLog.fromJson(Map<String, dynamic> json) {
    return TimeLog(
      name: json['name'] ?? '',
      fromTime: json['from_time'] ?? '',
      toTime: json['to_time'] ?? '',
      hours: (json['hours'] as num?)?.toDouble() ?? 0.0,
      customApprovalStatus: json['custom_approval_status'] ?? '',
      customTemplateData: json['custom_template_data'] ?? '',
    );
  }

  Map<String, dynamic> get parsedTemplateData {
    try {
      if (customTemplateData.isNotEmpty) {
        return json.decode(customTemplateData);
      }
    } catch (_) {}
    return {};
  }
}
