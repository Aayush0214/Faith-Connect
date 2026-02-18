part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckSession extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final User? user;
  const AuthStatusChanged(this.user);
}

class AuthLogoutRequested extends AuthEvent {}