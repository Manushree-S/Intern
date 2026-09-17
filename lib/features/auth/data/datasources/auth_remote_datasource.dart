import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signInWithEmailPassword({required String email, required String password});
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<void> changePassword({required String currentPassword, required String newPassword});
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> signOut();
  Future<UserModel> getCurrentUserModel();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (!doc.exists) return null;
        return UserModel.fromFirestore(doc);
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException(message: 'Authentication failed. Please try again.');
      }

      return await _fetchUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _mapFirebaseAuthErrorCode(e.code),
        code: e.code,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException(message: 'An unexpected authentication error occurred: $e');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException(message: 'Google sign-in was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException(message: 'Google authentication failed.');
      }

      return await _fetchUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseAuthErrorCode(e.code), code: e.code);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException(message: 'Google sign-in failed: $e');
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException(message: 'Apple authentication failed.');
      }

      return await _fetchUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseAuthErrorCode(e.code), code: e.code);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException(message: 'Apple sign-in failed: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthException(message: 'No authenticated user session found.');
    }

    try {
      // Re-authenticate before changing password
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      // Update Firestore mustChangePassword flag
      await _firestore.collection('users').doc(user.uid).update({
        'mustChangePassword': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseAuthErrorCode(e.code), code: e.code);
    } catch (e) {
      throw AuthException(message: 'Failed to update password: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseAuthErrorCode(e.code), code: e.code);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException(message: 'Failed to sign out: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUserModel() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException(message: 'User is not logged in.');
    }
    return await _fetchUserProfile(user.uid);
  }

  Future<UserModel> _fetchUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      // Non-provisioned user attempting to sign in
      await _firebaseAuth.signOut();
      throw const AuthException(
        message: 'Account not provisioned by institution. Contact your school administrator.',
        code: 'ACCOUNT_NOT_PROVISIONED',
      );
    }
    final model = UserModel.fromFirestore(doc);
    if (model.isDeactivated) {
      await _firebaseAuth.signOut();
      throw const AuthException(
        message: 'This account has been deactivated by the institution.',
        code: 'ACCOUNT_DEACTIVATED',
      );
    }
    return model;
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _mapFirebaseAuthErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid institution email or password.';
      case 'user-disabled':
        return 'This account has been disabled by the institution.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network connection issue. Please check your internet connection.';
      case 'weak-password':
        return 'Password should be at least 8 characters long.';
      default:
        return 'Authentication error ($code). Please try again.';
    }
  }
}
