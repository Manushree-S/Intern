import 'package:edtech_platform/features/auth/domain/entities/user_entity.dart';
import 'package:edtech_platform/features/auth/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserEntity Tests', () {
    const user = UserEntity(
      uid: 'user_001',
      email: 'student@school.edu',
      displayName: 'Alex Smith',
      role: UserRole.student,
      institutionId: 'inst_01',
      assignedClassIds: ['class_7a'],
      mustChangePassword: true,
      status: AccountStatus.active,
    );

    test('should hold correct fields and equality', () {
      expect(user.uid, 'user_001');
      expect(user.email, 'student@school.edu');
      expect(user.role, UserRole.student);
      expect(user.mustChangePassword, true);
      expect(user.isActive, true);
      expect(user.isDeactivated, false);
    });

    test('copyWith should update fields correctly', () {
      final updated = user.copyWith(
        mustChangePassword: false,
        status: AccountStatus.deactivated,
      );

      expect(updated.mustChangePassword, false);
      expect(updated.isDeactivated, true);
      expect(updated.isActive, false);
      expect(updated.uid, 'user_001');
    });
  });
}
