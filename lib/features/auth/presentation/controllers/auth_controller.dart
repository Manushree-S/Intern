import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// State for Authentication actions (login, reset, etc.)
class AuthActionState {
  final bool isLoading;
  final Failure? failure;
  final UserEntity? user;
  final String? successMessage;

  const AuthActionState({
    this.isLoading = false,
    this.failure,
    this.user,
    this.successMessage,
  });

  AuthActionState copyWith({
    bool? isLoading,
    Failure? failure,
    UserEntity? user,
    String? successMessage,
  }) {
    return AuthActionState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      user: user ?? this.user,
      successMessage: successMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthActionState> {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthActionState());

  Future<bool> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      final user = await _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on Failure catch (failure) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      final user = await _authRepository.signInWithGoogle();
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on Failure catch (failure) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      final user = await _authRepository.signInWithApple();
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on Failure catch (failure) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
  }

  Future<bool> changeFirstLoginPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      await _authRepository.changeFirstLoginPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password successfully updated!',
      );
      return true;
    } on Failure catch (failure) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
  }

  Future<bool> requestPasswordRecovery(String emailOrIdentifier) async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      await _authRepository.requestPasswordRecovery(
        emailOrIdentifier: emailOrIdentifier,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password recovery email sent. Please check your inbox.',
      );
      return true;
    } on Failure catch (failure) {
      state = state.copyWith(isLoading: false, failure: failure);
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      await _authRepository.signOut();
      state = const AuthActionState();
    } on Failure catch (failure) {
      state = state.copyWith(isLoading: false, failure: failure);
    }
  }

  void clearError() {
    state = state.copyWith(failure: null);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthActionState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});
