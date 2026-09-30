import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import 'auth_session_provider.dart';

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
    try {
      final repository = _ref.read(authRepositoryProvider);
      final rememberMe = _ref.read(rememberMeProvider);
      
      final sessionData = await repository.login(email, password, rememberMe);
      _ref.read(authSessionProvider.notifier).setSession(sessionData);
    } catch (e) {
      rethrow;
    } finally {
      _ref.read(authLoadingProvider.notifier).setLoading(false);
    }
  }

  Future<String?> sendResetEmail(String email) async {
    _ref.read(resetPasswordLoadingProvider.notifier).setLoading(true);
    try {
      final repository = _ref.read(authRepositoryProvider);
      return await repository.sendResetEmail(email);
    } catch (e) {
      rethrow;
    } finally {
      _ref.read(resetPasswordLoadingProvider.notifier).setLoading(false);
    }
  }

  Future<void> logout() async {
    final repository = _ref.read(authRepositoryProvider);
    await repository.logout();
    _ref.read(authSessionProvider.notifier).clearSession();
  }
}

