import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';

class InboxNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    return [];
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }
}

final inboxProvider = NotifierProvider<InboxNotifier, List<NotificationModel>>(() {
  return InboxNotifier();
});
