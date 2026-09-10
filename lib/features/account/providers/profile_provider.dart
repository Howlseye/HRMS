import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';

final profileProvider = Provider<ProfileModel>((ref) {
  return ProfileModel(
    name: 'Afdal Ramdan',
    role: 'UI/UX Designer',
  );
});
