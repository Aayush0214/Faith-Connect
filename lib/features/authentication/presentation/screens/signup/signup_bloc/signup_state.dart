part of 'signup_bloc.dart';

enum SignupStatus { initial, loading, success, failure }

final class SignupState extends Equatable {
  final File? profileImage;
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String faith;
  final String bio;
  final bool isPasswordVisible;
  final SignupStatus status;
  final String errorMessage;
  final int failureTimeStamp;
  final UserEntity? user;

  const SignupState({
    this.profileImage,
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.role = '',
    this.faith = '',
    this.bio = '',
    this.isPasswordVisible = false,
    this.status = SignupStatus.initial,
    this.errorMessage = '',
    this.failureTimeStamp = 1,
    this.user,
  });

  bool get isValidSignupForm =>
      fullName.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      role.isNotEmpty &&
      faith.isNotEmpty &&
      bio.isNotEmpty;

  SignupState copyWith({
    File? profileImage,
    String? fullName,
    String? email,
    String? password,
    String? role,
    String? faith,
    String? bio,
    UserEntity? user,
    SignupStatus? status,
    bool? isPasswordVisible,
    String? errorMessage,
    int? failureTimeStamp,
}) {
    return SignupState(
      profileImage: profileImage ?? this.profileImage,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      faith: faith ?? this.faith,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      user: user ?? this.user,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
      failureTimeStamp: failureTimeStamp ?? this.failureTimeStamp,
    );
}

  @override
  List<Object?> get props => [
    user,
    profileImage,
    fullName,
    email,
    password,
    role,
    faith,
    bio,
    status,
    errorMessage,
    failureTimeStamp,
    isPasswordVisible,
  ];
}
