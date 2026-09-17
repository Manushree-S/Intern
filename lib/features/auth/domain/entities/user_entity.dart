import 'user_role.dart';

enum AccountStatus { active, deactivated }

class UserEntity {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final String institutionId;
  final List<String> assignedClassIds;
  final bool mustChangePassword;
  final AccountStatus status;
  final String? profilePhotoUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.institutionId,
    this.assignedClassIds = const [],
    this.mustChangePassword = false,
    this.status = AccountStatus.active,
    this.profilePhotoUrl,
    this.createdAt,
  });

  bool get isActive => status == AccountStatus.active;
  bool get isDeactivated => status == AccountStatus.deactivated;

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    UserRole? role,
    String? institutionId,
    List<String>? assignedClassIds,
    bool? mustChangePassword,
    AccountStatus? status,
    String? profilePhotoUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      institutionId: institutionId ?? this.institutionId,
      assignedClassIds: assignedClassIds ?? this.assignedClassIds,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      status: status ?? this.status,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          role == other.role &&
          institutionId == other.institutionId &&
          mustChangePassword == other.mustChangePassword &&
          status == other.status;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      role.hashCode ^
      institutionId.hashCode ^
      mustChangePassword.hashCode ^
      status.hashCode;
}
