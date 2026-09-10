class NotificationModel {
  final String title;
  final String description;
  final String time;
  final String status;
  final bool isRead;
  final String? avatarAsset;

  NotificationModel({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    this.isRead = false,
    this.avatarAsset,
  });

  NotificationModel copyWith({
    String? title,
    String? description,
    String? time,
    String? status,
    bool? isRead,
    String? avatarAsset,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      avatarAsset: avatarAsset ?? this.avatarAsset,
    );
  }
}
