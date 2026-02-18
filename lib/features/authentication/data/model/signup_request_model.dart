import 'dart:io';

class SignupRequestModel {
  final String role;
  final String bio;
  final String email;
  final String faith;
  final String fullName;
  final String password;
  final File? profilePhoto;

  SignupRequestModel({
    required this.role,
    required this.bio,
    required this.email,
    required this.faith,
    required this.fullName,
    required this.password,
    required this.profilePhoto,
  });
}
