import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  UserEntity? _currentUser;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((userModel) {
      _currentUser = userModel;
      return userModel;
    });
  }

  @override
  UserEntity? get currentUser => _currentUser;

  @override
  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      _currentUser = userModel;
      return userModel;
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.code);
    } on AppException catch (e) {
      throw ServerFailure(message: e.message, code: e.code);
    } catch (e) {
      throw ServerFailure(message: 'Unexpected authentication failure: $e');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      _currentUser = userModel;
      return userModel;
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.code);
    } catch (e) {
      throw ServerFailure(message: 'Google authentication failure: $e');
    }
  }

  @override
  Future<UserEntity> signInWithApple() async {
    try {
      final userModel = await _remoteDataSource.signInWithApple();
      _currentUser = userModel;
      return userModel;
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.code);
    } catch (e) {
      throw ServerFailure(message: 'Apple authentication failure: $e');
    }
  }

  @override
  Future<void> changeFirstLoginPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(mustChangePassword: false);
      }
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.code);
    } catch (e) {
      throw ServerFailure(message: 'Failed to update password: $e');
    }
  }

  @override
  Future<void> requestPasswordRecovery({required String emailOrIdentifier}) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: emailOrIdentifier);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.code);
    } catch (e) {
      throw ServerFailure(message: 'Password reset request failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
      _currentUser = null;
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.code);
    } catch (e) {
      throw ServerFailure(message: 'Sign out failed: $e');
    }
  }
}
