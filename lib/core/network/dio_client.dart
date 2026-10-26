import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/shared_prefs_provider.dart';
import '../../features/auth/providers/auth_session_provider.dart';
import '../constants/app_strings.dart';
import 'api_endpoints.dart';
import '../router/app_router.dart';
import 'dart:convert';

final dioProvider = Provider<Dio>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final session = ref.watch(authSessionProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: '${dotenv.env['BASE_URL'] ?? ''}/api/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final sid = session['sid'] ?? prefs.getString('sid');
        if (sid != null && sid.isNotEmpty) {
          options.headers['Cookie'] = 'sid=$sid';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        String errorMessage = AppStrings.errorServerSide;
        
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.connectionError:
            errorMessage = AppStrings.errorConnection;
            break;
          case DioExceptionType.badResponse:
            if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
              if (e.requestOptions.path.contains(ApiEndpoints.login)) {
                errorMessage = AppStrings.loginFailed;
              } else {
                errorMessage = AppStrings.errorSessionExpired;
                ref.read(authSessionProvider.notifier).clearSession();
                AppRouter.router.go('/login');
              }
            } else if (e.response?.statusCode == 404 && e.requestOptions.path.contains(ApiEndpoints.resetPassword)) {
              errorMessage = AppStrings.errorEmailNotFound;
            } else if (e.response?.statusCode == 500) {
              errorMessage = AppStrings.errorInternalServer;
            } else if (e.response?.statusCode == 417) {
              dynamic data = e.response?.data;
              if (data is String) {
                try {
                  data = jsonDecode(data);
                } catch (_) {}
              }
              String rawMessage = '';
              if (data is Map<String, dynamic>) {
                if (data.containsKey('_server_messages')) {
                  try {
                    final messages = jsonDecode(data['_server_messages'] as String) as List;
                    if (messages.isNotEmpty) {
                      final msgObj = jsonDecode(messages.first as String);
                      rawMessage = msgObj['message']?.toString() ?? '';
                    }
                  } catch (_) {}
                }
                if (rawMessage.isEmpty && data.containsKey('exception')) {
                  rawMessage = data['exception'].toString();
                }
                if (rawMessage.isEmpty && data.containsKey('message')) {
                  rawMessage = data['message'].toString();
                }
              } else if (data is String) {
                rawMessage = data;
              }

              if (rawMessage.isNotEmpty) {
                errorMessage = _cleanErrorMessage(rawMessage);
              } else {
                errorMessage = '${AppStrings.errorSystem} 417';
              }
            } else {
              errorMessage = '${AppStrings.errorSystem} ${e.response?.statusCode}';
            }
            break;
          default:
            errorMessage = AppStrings.errorSystem;
            break;
        }
        
        final newError = e.copyWith(error: errorMessage);
        return handler.next(newError);
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  return dio;
});

String _cleanErrorMessage(String raw) {
  String cleaned = raw.split(RegExp(r'\s*:\s*<a|\s*<a')).first.trim();
  if (cleaned.contains(': ')) {
    final firstPart = cleaned.split(': ').first;
    if (firstPart.contains('.') || firstPart.endsWith('Error') || firstPart.endsWith('Exception')) {
      cleaned = cleaned.substring(firstPart.length + 2).trim();
    }
  }
  return cleaned.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
