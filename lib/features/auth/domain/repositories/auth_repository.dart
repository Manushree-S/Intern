import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Stream of user auth state
  Stream<UserEntity?> get authStateChanges;

  /// Current cached or active user entity
  UserEntity? get currentUser;

  /// Authenticate using institution-issued email and password
  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Authenticate using Google institutional account
  Future<UserEntity> signInWithGoogle();

  /// Authenticate using Apple institutional account (mandatory for iOS)
  Future<UserEntity> signInWithApple();

  /// Force change password on first login
  Future<void> changeFirstLoginPassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Request institution password reset / recovery instruction
  Future<void> requestPasswordRecovery({required String emailOrIdentifier});

  /// Sign out current user
  Future<void> signOut();
}
