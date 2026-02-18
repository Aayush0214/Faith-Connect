import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String role;
  final String? bio;
  final String email;
  final String faith;
  final String fullName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? profilePhotoUrl;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.faith,
    this.profilePhotoUrl,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    role,
    faith,
    profilePhotoUrl,
    bio,
    createdAt,
    updatedAt,
  ];
}