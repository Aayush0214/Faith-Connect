part of 'leader_profile_bloc.dart';

sealed class LeaderProfileState extends Equatable {
  const LeaderProfileState();
}

final class LeaderProfileInitial extends LeaderProfileState {
  @override
  List<Object> get props => [];
}

final class LeaderProfileSuccessState extends LeaderProfileState {
  final Map<String, int> stats;

  const LeaderProfileSuccessState({required this.stats});

  @override
  List<Object> get props => [stats];
}

final class LeaderProfileErrorState extends LeaderProfileState {
  final String errorMessage;

  const LeaderProfileErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
