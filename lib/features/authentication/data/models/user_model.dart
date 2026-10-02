import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.name,
    required super.role,
  });

  factory UserModel.fromFirestore(
      Map<String, dynamic> json,
      ) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      role: _roleFromString(
        json['role'] ?? 'fisherman',
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.name,
    };
  }

  static UserRole _roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'vendor':
        return UserRole.vendor;

      case 'admin':
        return UserRole.admin;

      case 'fisherman':
      default:
        return UserRole.fisherman;
    }
  }
}