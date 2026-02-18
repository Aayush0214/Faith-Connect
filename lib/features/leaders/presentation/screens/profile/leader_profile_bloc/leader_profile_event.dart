part of 'leader_profile_bloc.dart';

sealed class LeaderProfileEvent extends Equatable {
  const LeaderProfileEvent();
}

final class LogoutEvent extends LeaderProfileEvent {
  @override
  List<Object> get props => [];
}