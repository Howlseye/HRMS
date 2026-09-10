import 'package:flutter_riverpod/flutter_riverpod.dart';

class RememberMeNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle(bool value) => state = value;
}

final rememberMeProvider = NotifierProvider<RememberMeNotifier, bool>(() => RememberMeNotifier());

class AuthLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setLoading(bool value) => state = value;
}

final authLoadingProvider = NotifierProvider<AuthLoadingNotifier, bool>(() => AuthLoadingNotifier());

final authControllerProvider = Provider((ref) => AuthController(ref));

class ResetPasswordLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setLoading(bool value) => state = value;
}

final resetPasswordLoadingProvider = NotifierProvider<ResetPasswordLoadingNotifier, bool>(() => ResetPasswordLoadingNotifier());

class AuthController {
  final Ref _ref;
  AuthController(this._ref);

  Future<void> login(String email, String password) async {
    _ref.read(authLoadingProvider.notifier).setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    _ref.read(authLoadingProvider.notifier).setLoading(false);
  }

  Future<void> sendResetEmail(String email) async {
    _ref.read(resetPasswordLoadingProvider.notifier).setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    _ref.read(resetPasswordLoadingProvider.notifier).setLoading(false);
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
