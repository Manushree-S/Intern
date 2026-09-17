import 'package:edtech_platform/features/auth/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserRole Enum Tests', () {
    test('should parse student correctly from string', () {
      expect(UserRole.fromString('student'), UserRole.student);
      expect(UserRole.fromString('STUDENT'), UserRole.student);
      expect(UserRole.fromString(null), UserRole.student);
    });

    test('should parse teacher and staff correctly from string', () {
      expect(UserRole.fromString('teacher'), UserRole.teacher);
      expect(UserRole.fromString('staff'), UserRole.teacher);
      expect(UserRole.fromString('TEACHER'), UserRole.teacher);
    });

    test('should parse admin and non_technical_staff correctly from string', () {
      expect(UserRole.fromString('admin'), UserRole.admin);
      expect(UserRole.fromString('non_technical_staff'), UserRole.admin);
      expect(UserRole.fromString('ADMIN'), UserRole.admin);
    });

    test('should parse parent role correctly for future extensibility', () {
      expect(UserRole.fromString('parent'), UserRole.parent);
    });

    test('getter helpers should return correct boolean states', () {
      const student = UserRole.student;
      expect(student.isStudent, true);
      expect(student.isTeacher, false);
      expect(student.isAdmin, false);

      const teacher = UserRole.teacher;
      expect(teacher.isTeacher, true);
      expect(teacher.isStudent, false);
      expect(teacher.isAdmin, false);

      const admin = UserRole.admin;
      expect(admin.isAdmin, true);
      expect(admin.isStudent, false);
      expect(admin.isTeacher, false);
    });
  });
}
