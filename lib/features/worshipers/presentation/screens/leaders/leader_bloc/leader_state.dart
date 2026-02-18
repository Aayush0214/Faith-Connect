part of 'leader_bloc.dart';

enum LeaderStatus{
  initial,
  loading,
  loaded,
  failure,
}

class LeaderState extends Equatable {
  final List<LeaderEntity> exploreLeaders;
  final List<LeaderEntity> myLeaders;
  final String searchQuery;
  final LeaderStatus status;
  final String errorMessage;
  final int errorTimeStamp;
  final bool isFetchingMore;
  final bool hasMoreExplore;
  final bool hasMoreMyLeaders;

  const LeaderState({
    this.exploreLeaders = const [],
    this.myLeaders = const [],
    this.searchQuery = '',
    this.errorMessage = '',
    this.errorTimeStamp = 0,
    this.status = LeaderStatus.initial,
    this.isFetchingMore = false,
    this.hasMoreExplore = true,
    this.hasMoreMyLeaders = true,
  });

  LeaderState copyWith({
    List<LeaderEntity>? exploreLeaders,
    List<LeaderEntity>? myLeaders,
    LeaderStatus? status,
    String? searchQuery,
    String? errorMessage,
    int? errorTimeStamp,
    bool? isFetchingMore,
    bool? hasMoreExplore,
    bool? hasMoreMyLeaders,
  }) {
    return LeaderState(
      exploreLeaders: exploreLeaders ?? this.exploreLeaders,
      myLeaders: myLeaders ?? this.myLeaders,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      errorTimeStamp: errorTimeStamp ?? this.errorTimeStamp,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMoreExplore: hasMoreExplore ?? this.hasMoreExplore,
      hasMoreMyLeaders: hasMoreMyLeaders ?? this.hasMoreMyLeaders,
    );
  }

  @override
  List<Object?> get props =>
      [
        exploreLeaders,
        myLeaders,
        searchQuery,
        status,
        isFetchingMore,
        hasMoreExplore,
        hasMoreMyLeaders,
        errorMessage,
        errorTimeStamp,
      ];
}