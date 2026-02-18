part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileSuccessState extends ProfileState{
  final Map<String, int> worshiperStats;

  const ProfileSuccessState({required this.worshiperStats});

  @override
  List<Object> get props => [worshiperStats];
}

final class ProfileErrorState extends ProfileState {
  final String errorMessage;

  const ProfileErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
