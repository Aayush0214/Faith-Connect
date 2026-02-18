

import '../entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.role,
    required super.faith,
    super.profilePhotoUrl,
    super.bio,
    super.createdAt,
    super.updatedAt,
  });

  // Supabase (JSON) se Model banana
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // 1. Mandatory Fields (With Fallbacks to avoid crash)
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'No Name',
      role: json['role']?.toString() ?? 'worshiper',

      // 2. Nullable Fields (No fallback needed, they can be null)
      faith: json['faith']?.toString() ?? 'unknown',
      profilePhotoUrl: json['profile_photo_url'] as String?,
      bio: json['bio'] as String?,

      // 3. Date Handling (Safe parse)
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  // Model se JSON banana (Supabase/Database ke liye)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'faith': faith,
      'profile_photo_url': profilePhotoUrl,
      'bio': bio,
      // created_at usually DB default NOW() se handle karta hai
      // updated_at ko hum manually bhej sakte hain
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // copyWith for Bloc/State updates
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? faith,
    String? profilePhotoUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      faith: faith ?? this.faith,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}