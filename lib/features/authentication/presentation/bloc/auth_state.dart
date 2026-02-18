part of 'auth_bloc.dart';

sealed class AppAuthState extends Equatable {
  const AppAuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AppAuthState {}

final class AuthAuthenticated extends AppAuthState {
  final User user; // Ye Supabase wala User hai
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthUnauthenticated extends AppAuthState {}
