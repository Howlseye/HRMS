import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/main/screens/main_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/attendance/screens/attendance_screen.dart';
import '../../features/attendance/screens/attendance_log_screen.dart';
import '../../features/attendance/screens/attendance_detail_screen.dart';
import '../../features/attendance/models/attendance_log_entry.dart';
import '../../features/employee/screens/employee_detail_screen.dart';
import '../../features/employee/models/employee_model.dart';
import '../../features/attendance/screens/attendance_success_screen.dart';

class AppRouter {
  AppRouter._();

  static CustomTransitionPage _buildPageWithDefaultTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/attendance',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const AttendanceScreen(),
        ),
      ),
      GoRoute(
        path: '/attendance-log',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const AttendanceLogScreen(),
        ),
      ),
      GoRoute(
        path: '/attendance-detail',
        pageBuilder: (context, state) {
          final logEntry = state.extra as AttendanceLogEntry;
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: AttendanceDetailScreen(logEntry: logEntry),
          );
        },
      ),
      GoRoute(
        path: '/attendance-success',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: AttendanceSuccessScreen(
              isCheckIn: data['isCheckIn'] ?? true,
              date: data['date'] ?? '',
              timeRange: data['timeRange'] ?? '',
              alertMessage: data['alertMessage'],
            ),
          );
        },
      ),
      GoRoute(
        path: '/employee-detail',
        pageBuilder: (context, state) {
          final employee = state.extra as EmployeeModel;
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: EmployeeDetailScreen(employee: employee),
          );
        },
      ),
      GoRoute(
        path: '/main',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const MainScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
    ],
  );
}
