import 'package:equatable/equatable.dart';

enum UserRole {
  fisherman,
  vendor,
  admin,
}

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final UserRole role;

  const UserEntity({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    name,
    role,
  ];
}