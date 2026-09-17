import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    required super.role,
    required super.institutionId,
    super.assignedClassIds,
    super.mustChangePassword,
    super.status,
    super.profilePhotoUrl,
    super.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel.fromMap(data, doc.id);
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      role: UserRole.fromString(map['role'] as String?),
      institutionId: map['institutionId'] as String? ?? '',
      assignedClassIds: List<String>.from(map['assignedClassIds'] as List? ?? []),
      mustChangePassword: map['mustChangePassword'] as bool? ?? false,
      status: (map['status'] as String? ?? 'active').toLowerCase() == 'deactivated'
          ? AccountStatus.deactivated
          : AccountStatus.active,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.value,
      'institutionId': institutionId,
      'assignedClassIds': assignedClassIds,
      'mustChangePassword': mustChangePassword,
      'status': status == AccountStatus.active ? 'active' : 'deactivated',
      'profilePhotoUrl': profilePhotoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
