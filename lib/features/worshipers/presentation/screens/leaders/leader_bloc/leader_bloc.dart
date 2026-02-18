import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/worshipers/data/models/leader_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/leader_entity.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/leader_usecases/toggle_follow_leader.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/leader_usecases/fetch_explore_leaders.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/leader_usecases/fetch_followed_leaders.dart';

part 'leader_event.dart';
part 'leader_state.dart';

class LeaderBloc extends Bloc<LeaderEvent, LeaderState> {
  final pageSize = 10;
  final FetchExploreLeadersUsecase _fetchExploreLeadersUsecase;
  final FetchFollowedLeadersUsecase _fetchFollowedLeadersUsecase;
  final FollowUnfollowLeaderUsecase _followLeaderUsecase;

  LeaderBloc({
    required FetchExploreLeadersUsecase fetchExploreLeaderUsecase,
    required FetchFollowedLeadersUsecase fetchFollowedLeadersUsecase,
    required FollowUnfollowLeaderUsecase followLeaderUsecase,
  }) : _fetchExploreLeadersUsecase = fetchExploreLeaderUsecase,
        _fetchFollowedLeadersUsecase = fetchFollowedLeadersUsecase,
        _followLeaderUsecase = followLeaderUsecase,
        super(const LeaderState()) {

    on<SearchQueryChanged>(_onSearchQuery);
    on<FetchLeadersEvent>(_onFetchLeaders);
    on<FetchMoreLeaders>(_onFetchMoreLeaders);
    on<ToggleFollowEvent>(_onToggleFollow);
  }

  Future<void> _onSearchQuery(SearchQueryChanged event, Emitter<LeaderState> emit) async{
    emit(state.copyWith(searchQuery: event.query, status: LeaderStatus.loading));
    // 500ms wait logic yahan UI ya Bloc transformer mein lag sakta h
    add(FetchLeadersEvent(isExplore: event.isExplore));
  }

  // 1. Fetch Explore
  Future<void> _onFetchLeaders(FetchLeadersEvent event, Emitter<LeaderState> emit) async {
    emit(state.copyWith(status: LeaderStatus.loading));

    final results = event.isExplore
        ? await _fetchExploreLeadersUsecase(from: 0, to: pageSize - 1, searchQuery: state.searchQuery)
        : await _fetchFollowedLeadersUsecase(from: 0, to: pageSize - 1, searchQuery: state.searchQuery);

    results.fold(
      (failure){
        emit(
          state.copyWith(
            status: LeaderStatus.failure,
            errorMessage: failure.message,
            errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
          )
        );
      },
      (leaders){
        if (event.isExplore) {
          emit(state.copyWith(exploreLeaders: leaders, status: LeaderStatus.loaded, hasMoreExplore: leaders.length == pageSize));
        } else {
          emit(state.copyWith(myLeaders: leaders, status: LeaderStatus.loaded, hasMoreMyLeaders: leaders.length == pageSize));
        }
      },
    );
  }

  // 2. Fetch My Leaders
  Future<void> _onFetchMoreLeaders(FetchMoreLeaders event, Emitter<LeaderState> emit) async {
    if (state.isFetchingMore) return;
    emit(state.copyWith(isFetchingMore: true));

    final int from = event.isExplore ? state.exploreLeaders.length : state.myLeaders.length;
    final int to = from + pageSize;

    final results = event.isExplore
        ? await _fetchExploreLeadersUsecase(from: from, to: to, searchQuery: state.searchQuery)
        : await _fetchFollowedLeadersUsecase(from: from, to: to, searchQuery: state.searchQuery);

    results.fold(
      (failure){
        emit(
            state.copyWith(
              status: LeaderStatus.failure,
              errorMessage: failure.message,
              errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
            )
        );
      },
      (newLeaders){
        final maxReached = newLeaders.length < pageSize;
        if (event.isExplore) {
          emit(state.copyWith(
              exploreLeaders: [...state.exploreLeaders, ...newLeaders],
              isFetchingMore: false,
              hasMoreExplore: !maxReached,
          ));
        } else {
          emit(state.copyWith(
              myLeaders: [...state.myLeaders, ...newLeaders],
              isFetchingMore: false,
              hasMoreMyLeaders: !maxReached,
          ));
        }
      },
    );

  }

  // 3. Toggle Follow (Optimistic Update)
  Future<void> _onToggleFollow(ToggleFollowEvent event, Emitter<LeaderState> emit) async {
    final originalLeaders = event.isExplore ? List<LeaderEntity>.from(state.exploreLeaders) : List<LeaderEntity>.from(state.myLeaders);
    final List<LeaderEntity> updatedLeaders;
    if(event.isExplore) {
      updatedLeaders = state.exploreLeaders.map((leader){
        if(leader.id == event.leaderId){
          final isFollowed = !leader.isFollowing;
          final followersCount = isFollowed ? leader.followersCount + 1 : leader.followersCount > 0 ? leader.followersCount - 1 : 0;
          return (leader as LeaderModel).copyWith(isFollowing: isFollowed, followersCount: followersCount);
        }
        return leader;
      }).toList();
      emit(state.copyWith(exploreLeaders: updatedLeaders));
    } else {
      updatedLeaders = state.myLeaders.map((leader){
        if(leader.id == event.leaderId){
          final isFollowed = !leader.isFollowing;
          return (leader as LeaderModel).copyWith(isFollowing: isFollowed);
        }
        return leader;
      }).toList();
      emit(state.copyWith(myLeaders: updatedLeaders));
    }

    final result = await _followLeaderUsecase(event.leaderId);

    result.fold(
       (failure){
         if (event.isExplore) {
           emit(
               state.copyWith(
                 status: LeaderStatus.failure,
                 errorMessage: failure.message,
                 exploreLeaders: originalLeaders,
                 errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
               )
           );
         } else {
           emit(
               state.copyWith(
                 myLeaders: originalLeaders,
                 status: LeaderStatus.failure,
                 errorMessage: failure.message,
                 errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
               )
           );
         }
      },
      (success){

      },
    );
  }
}

