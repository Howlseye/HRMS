class ShiftModel {
  final String shiftType;
  final String startTime;
  final String endTime;

  ShiftModel({
    required this.shiftType,
    required this.startTime,
    required this.endTime,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      shiftType: json['name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}
