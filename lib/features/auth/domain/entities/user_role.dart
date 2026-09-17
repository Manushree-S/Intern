/// The exact three active user roles in v1, with extensible parent role prepared for v2.
enum UserRole {
  student('student'),
  teacher('teacher'),
  admin('admin'),
  parent('parent'); // Prepared for v2 if client approves

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String? roleString) {
    if (roleString == null) return UserRole.student;
    switch (roleString.toLowerCase().trim()) {
      case 'teacher':
      case 'staff':
        return UserRole.teacher;
      case 'admin':
      case 'non_technical_staff':
        return UserRole.admin;
      case 'parent':
        return UserRole.parent;
      case 'student':
      default:
        return UserRole.student;
    }
  }

  bool get isStudent => this == UserRole.student;
  bool get isTeacher => this == UserRole.teacher;
  bool get isAdmin => this == UserRole.admin;
  bool get isParent => this == UserRole.parent;
}
