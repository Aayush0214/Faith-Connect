part of 'login_bloc.dart';

enum LoginStatus {initial, loading, success, failure}

final class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final String errorMessage;
  final int failureTimeStamp;
  final LoginStatus status;
  final UserEntity? user;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.errorMessage = '',
    this.failureTimeStamp = 0,
    this.status = LoginStatus.initial,
    this.user,
  });

  bool get isValidLoginForm => email.isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    int? failureTimeStamp,
    bool? isPasswordVisible,
    LoginStatus? status,
    UserEntity? user,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      failureTimeStamp: failureTimeStamp ?? this.failureTimeStamp,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    email,
    status,
    user,
    password,
    errorMessage,
    failureTimeStamp,
    isPasswordVisible,
  ];
}