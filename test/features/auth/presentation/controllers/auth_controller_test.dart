import 'package:edtech_platform/core/errors/failures.dart';
import 'package:edtech_platform/features/auth/domain/entities/user_entity.dart';
import 'package:edtech_platform/features/auth/domain/entities/user_role.dart';
import 'package:edtech_platform/features/auth/domain/repositories/auth_repository.dart';
import 'package:edtech_platform/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthController authController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authController = AuthController(authRepository: mockAuthRepository);
  });

  const testUser = UserEntity(
    uid: 'u_123',
    email: 'teacher@school.edu',
    displayName: 'Professor Davis',
    role: UserRole.teacher,
    institutionId: 'inst_01',
  );

  group('AuthController Tests', () {
    test('initial state should be idle with null user and failure', () {
      expect(authController.state.isLoading, false);
      expect(authController.state.user, null);
      expect(authController.state.failure, null);
    });

    test('signInWithEmailPassword success should update user and stop loading', () async {
      when(() => mockAuthRepository.signInWithEmailPassword(
            email: 'teacher@school.edu',
            password: 'password123',
          )).thenAnswer((_) async => testUser);

      final result = await authController.signInWithEmailPassword(
        email: 'teacher@school.edu',
        password: 'password123',
      );

      expect(result, true);
      expect(authController.state.isLoading, false);
      expect(authController.state.user, testUser);
      expect(authController.state.failure, null);
    });

    test('signInWithEmailPassword failure should set AuthFailure', () async {
      when(() => mockAuthRepository.signInWithEmailPassword(
            email: 'teacher@school.edu',
            password: 'wrong',
          )).thenThrow(const AuthFailure(message: 'Invalid credentials.'));

      final result = await authController.signInWithEmailPassword(
        email: 'teacher@school.edu',
        password: 'wrong',
      );

      expect(result, false);
      expect(authController.state.isLoading, false);
      expect(authController.state.user, null);
      expect(authController.state.failure, isA<AuthFailure>());
      expect(authController.state.failure?.message, 'Invalid credentials.');
    });
  });
}
