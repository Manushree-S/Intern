import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/domain/entities/user_role.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/deactivated_account_screen.dart';
import '../../features/auth/presentation/screens/first_login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/student/presentation/screens/student_dashboard_screen.dart';
import '../../features/teacher/presentation/screens/teacher_dashboard_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: RouteNames.login,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final user = authState.asData?.value;
      final isAuth = user != null;
      final currentLoc = state.uri.path;

      final isAuthRoute = currentLoc == RouteNames.login ||
          currentLoc == RouteNames.forgotPassword;

      // 1. Unauthenticated users must only access auth routes
      if (!isAuth) {
        return isAuthRoute ? null : RouteNames.login;
      }

      // 2. Account deactivation check
      if (user.isDeactivated) {
        return currentLoc == RouteNames.accountDeactivated
            ? null
            : RouteNames.accountDeactivated;
      }

      // 3. Mandatory First-Login Password Reset
      if (user.mustChangePassword) {
        return currentLoc == RouteNames.firstLogin
            ? null
            : RouteNames.firstLogin;
      }

      // 4. If logged in and on an auth screen, redirect to appropriate role dashboard
      if (isAuthRoute ||
          currentLoc == RouteNames.firstLogin ||
          currentLoc == RouteNames.accountDeactivated ||
          currentLoc == RouteNames.splash) {
        switch (user.role) {
          case UserRole.student:
            return RouteNames.studentDashboard;
          case UserRole.teacher:
            return RouteNames.teacherDashboard;
          case UserRole.admin:
            return RouteNames.adminDashboard;
          case UserRole.parent:
            return RouteNames.studentDashboard; // fallback
        }
      }

      // 5. Strict Role Isolation Guards
      // Prevent Students from accessing Teacher or Admin routes
      if (user.role == UserRole.student) {
        if (currentLoc.startsWith('/teacher') || currentLoc.startsWith('/admin')) {
          return RouteNames.studentDashboard;
        }
      }

      // Prevent Teachers from accessing Admin routes or Student-only personal progress
      if (user.role == UserRole.teacher) {
        if (currentLoc.startsWith('/admin')) {
          return RouteNames.teacherDashboard;
        }
      }

      // Prevent Admins from accessing Academic grading/quizzes in Student or Teacher trees
      if (user.role == UserRole.admin) {
        if (currentLoc.startsWith('/student') || currentLoc.startsWith('/teacher')) {
          return RouteNames.adminDashboard;
        }
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.firstLogin,
        builder: (context, state) => const FirstLoginScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.accountDeactivated,
        builder: (context, state) => const DeactivatedAccountScreen(),
      ),

      // Student Shell
      GoRoute(
        path: RouteNames.studentDashboard,
        builder: (context, state) => const StudentDashboardScreen(),
      ),

      // Teacher Shell
      GoRoute(
        path: RouteNames.teacherDashboard,
        builder: (context, state) => const TeacherDashboardScreen(),
      ),

      // Admin Shell
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
