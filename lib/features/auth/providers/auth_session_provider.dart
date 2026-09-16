import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthSessionNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => {};

  void setSession(Map<String, String> sessionData) {
    state = sessionData;
  }

  void clearSession() {
    state = {};
  }
}

final authSessionProvider = NotifierProvider<AuthSessionNotifier, Map<String, String>>(() {
  return AuthSessionNotifier();
});
