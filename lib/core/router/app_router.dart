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
import '../../features/leave/screens/leave_screen.dart';
import '../../features/leave/screens/leave_detail_screen.dart';
import '../../features/leave/screens/new_leave_screen.dart';
import '../../features/leave/screens/success_leave_screen.dart';
import '../../features/leave/models/leave_detail_args_model.dart';
import '../../features/reimbursement/screens/reimbursement_screen.dart';
import '../../features/reimbursement/screens/reimbursement_detail_screen.dart';
import '../../features/reimbursement/screens/new_reimbursement_screen.dart';
import '../../features/reimbursement/screens/reimbursement_success_screen.dart';
import '../../features/reimbursement/models/reimbursement_model.dart';
import '../../core/widgets/success_screen.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/announcement/screens/announcement_screen.dart';
import '../../features/announcement/screens/announcement_detail_screen.dart';
import '../../features/announcement/models/announcement_model.dart';

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
        path: '/announcement',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const AnnouncementScreen(),
        ),
      ),
      GoRoute(
        path: '/announcement/detail',
        pageBuilder: (context, state) {
          final args = state.extra as AnnouncementModel;
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: AnnouncementDetailScreen(announcement: args),
          );
        },
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
        path: '/leave',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const LeaveScreen(),
        ),
      ),
      GoRoute(
        path: '/leave/detail',
        pageBuilder: (context, state) {
          final args = state.extra as LeaveDetailArgs;
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LeaveDetailScreen(args: args),
          );
        },
      ),
      GoRoute(
        path: '/leave/new',
        pageBuilder: (context, state) {
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const NewLeaveScreen(),
          );
        },
      ),
      GoRoute(
        path: '/leave/success',
        pageBuilder: (context, state) {
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const SuccessLeaveScreen(),
          );
        },
      ),
      GoRoute(
        path: '/reimbursement',
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ReimbursementScreen(),
        ),
      ),
      GoRoute(
        path: '/reimbursement/detail',
        pageBuilder: (context, state) {
          final reimbursement = state.extra as ReimbursementModel;
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: ReimbursementDetailScreen(reimbursement: reimbursement),
          );
        },
      ),
      GoRoute(
        path: '/reimbursement/new',
        pageBuilder: (context, state) {
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const NewReimbursementScreen(),
          );
        },
      ),
      GoRoute(
        path: '/reimbursement/success',
        pageBuilder: (context, state) {
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const ReimbursementSuccessScreen(),
          );
        },
      ),
      GoRoute(
        path: '/reimbursement/cancel-success',
        pageBuilder: (context, state) {
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: SuccessScreen(
              title: AppStrings.cancelReimburseSuccessTitle,
              subtitleWidget: Text(
                AppStrings.cancelReimburseSuccessDesc,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
              buttonText: AppStrings.kembali,
              onButtonPressed: () {
                context.go('/reimbursement');
              },
              onClosePressed: () {
                context.go('/reimbursement');
              },
            ),
          );
        },
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
