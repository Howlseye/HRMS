import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/shared_prefs_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepository(dio, prefs);
});

class AuthRepository {
  final Dio _dio;
  final SharedPreferences _prefs;

  AuthRepository(this._dio, this._prefs);

  Future<Map<String, String>> login(String email, String password, bool rememberMe) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'usr': email,
          'pwd': password,
        },
      );

      final Map<String, String> sessionData = {};
      final cookies = response.headers['set-cookie'];
      
      if (cookies != null) {
        for (final cookie in cookies) {
          final parts = cookie.split(';');
          if (parts.isNotEmpty) {
            final keyValue = parts.first.split('=');
            if (keyValue.length == 2) {
              final key = keyValue[0].trim();
              final value = Uri.decodeComponent(keyValue[1].trim());
              if (['sid', 'system_user', 'full_name', 'user_id', 'user_image'].contains(key)) {
                sessionData[key] = value;
                await _prefs.setString(key, value);
              }
            }
          }
        }
      }


      await _prefs.setBool('is_remember_me', rememberMe);
      if (rememberMe) {
        await _prefs.setString('remembered_email', email);
      } else {
        await _prefs.remove('remembered_email');
      }

      return sessionData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final keysToRemove = [
        'sid', 
        'system_user', 
        'full_name', 
        'user_id', 
        'user_image', 
        'is_remember_me',
        'remembered_email'
      ];
      for (final key in keysToRemove) {
        await _prefs.remove(key);
      }
      
      await _dio.post(ApiEndpoints.logout);
    } catch (e) {
      return;
    }
  }
}
