class RouteNames {
  RouteNames._();

  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String firstLogin = '/first-login';
  static const String forgotPassword = '/forgot-password';
  static const String accountDeactivated = '/account-deactivated';

  // Student Shell Routes
  static const String studentDashboard = '/student/dashboard';
  static const String studentCourses = '/student/courses';
  static const String studentCourseDetail = '/student/courses/:courseId';
  static const String studentLessonView = '/student/courses/:courseId/lessons/:lessonId';
  static const String studentQuizzes = '/student/quizzes/:quizId';
  static const String studentQuizRunner = '/student/quizzes/:quizId/take';
  static const String studentQuizResult = '/student/quizzes/:quizId/result';
  static const String studentAssignments = '/student/assignments';
  static const String studentAssignmentSubmit = '/student/assignments/:assignmentId/submit';
  static const String studentAttendance = '/student/attendance';
  static const String studentProgress = '/student/progress';
  static const String studentNotifications = '/student/notifications';
  static const String studentProfile = '/student/profile';

  // Teacher Shell Routes
  static const String teacherDashboard = '/teacher/dashboard';
  static const String teacherClasses = '/teacher/classes';
  static const String teacherClassDetail = '/teacher/classes/:classId';
  static const String teacherAttendance = '/teacher/attendance/:classId';
  static const String teacherSubmissions = '/teacher/submissions';
  static const String teacherEvaluation = '/teacher/submissions/:submissionId/evaluate';
  static const String teacherReports = '/teacher/reports/:classId';
  static const String teacherNotifications = '/teacher/notifications';
  static const String teacherProfile = '/teacher/profile';

  // Admin Shell Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminCsvImport = '/admin/users/csv-import';
  static const String adminClasses = '/admin/classes';
  static const String adminFees = '/admin/fees';
  static const String adminReports = '/admin/reports';
  static const String adminProfile = '/admin/profile';
}
