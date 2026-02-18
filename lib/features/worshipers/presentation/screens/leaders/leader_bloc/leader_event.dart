part of 'leader_bloc.dart';

sealed class LeaderEvent extends Equatable {
  const LeaderEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeadersEvent extends LeaderEvent {
  final bool isExplore;

  const FetchLeadersEvent({required this.isExplore});

  @override
  List<Object?> get props => [isExplore];
}

class FetchMoreLeaders extends LeaderEvent {
  final bool isExplore;

  const FetchMoreLeaders({required this.isExplore});

  @override
  List<Object?> get props => [isExplore];
}

class SearchQueryChanged extends LeaderEvent{
  final String query;
  final bool isExplore;

  const SearchQueryChanged({required this.query, required this.isExplore});

  @override
  List<Object?> get props => [query, isExplore];
}

class ToggleFollowEvent extends LeaderEvent {
  final String leaderId;
  final bool isExplore;

  const ToggleFollowEvent({required this.leaderId, required this.isExplore});

  @override
  List<Object?> get props => [leaderId, isExplore];
}
