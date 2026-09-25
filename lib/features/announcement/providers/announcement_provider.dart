import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/announcement_model.dart';

final announcementProvider = Provider<List<AnnouncementModel>>((ref) {
  return [];
});
