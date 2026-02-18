part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

final class SignupNameChanged extends SignupEvent {
  final String fullName;
  const SignupNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

final class SignupEmailChanged extends SignupEvent {
  final String email;
  const SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

final class SignupPasswordChanged extends SignupEvent {
  final String password;
  const SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

final class SignupRoleChanged extends SignupEvent {
  final String role;

  const SignupRoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

final class SignupFaithChanged extends SignupEvent {
  final String faith;

  const SignupFaithChanged(this.faith);

  @override
  List<Object?> get props => [faith];
}

final class SignupBioChanged extends SignupEvent {
  final String bio;

  const SignupBioChanged(this.bio);

  @override
  List<Object?> get props => [bio];
}

final class SignupPasswordVisibilityToggled extends SignupEvent {}

final class SignupSubmitted extends SignupEvent {}

class SignupGalleryImageRequested extends SignupEvent {}

class SignupCameraImageRequested extends SignupEvent {}