class ShiftModel {
  final String shiftType;
  final String startTime;
  final String endTime;
  final double? latitude;
  final double? longitude;
  final double? checkinRadius;
  final String? locationName;

  ShiftModel({
    required this.shiftType,
    required this.startTime,
    required this.endTime,
    this.latitude,
    this.longitude,
    this.checkinRadius,
    this.locationName,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      shiftType: json['name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }

  ShiftModel copyWith({
    String? shiftType,
    String? startTime,
    String? endTime,
    double? latitude,
    double? longitude,
    double? checkinRadius,
    String? locationName,
  }) {
    return ShiftModel(
      shiftType: shiftType ?? this.shiftType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      checkinRadius: checkinRadius ?? this.checkinRadius,
      locationName: locationName ?? this.locationName,
    );
  }
}
