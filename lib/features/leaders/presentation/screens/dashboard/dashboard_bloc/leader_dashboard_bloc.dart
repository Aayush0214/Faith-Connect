import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/core/common/entities/post_entity.dart';
import 'package:faith_connect/core/common/entities/user_entity.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/delete_leader_posts.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/get_leader_followers.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/get_leader_posts.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/get_leader_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../../core/common/models/post_model.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../social_action/domain/usecases/get_social_update_usecase.dart';
import '../../../../../social_action/domain/usecases/like_unlike_usecase.dart';
import '../../../../../social_action/domain/usecases/save_unsave_usecase.dart';
import '../../../../../worshipers/data/models/leader_model.dart';
import '../../../../../worshipers/domain/entities/leader_entity.dart';
import '../../../../../worshipers/domain/use_cases/leader_usecases/toggle_follow_leader.dart';

part 'leader_dashboard_event.dart';

part 'leader_dashboard_state.dart';

class LeaderDashboardBloc extends Bloc<LeaderDashboardEvent, LeaderDashboardState> {
  final GetLeaderFollowersUsecase _getLeaderFollowersUsecase;
  final DeleteLeaderPostUsecase _deleteLeaderPostUsecase;
  final FollowUnfollowLeaderUsecase _followUnFollowLeaderUsecase;
  final GetLeaderProfileDataUsecase _getLeaderProfile;
  final GetLeaderPostsUsecase _getLeaderPostsUsecase;
  final LikeUnlikeUseCase _likeUnlikeUseCase;
  final SaveUnsaveUseCase _saveUnsaveUseCase;
  final GetSocialUpdatesUseCase _getSocialUpdatesUseCase;
  StreamSubscription? _socialSubscription;
  final int pageSize = 10;

  LeaderDashboardBloc({
    required GetLeaderProfileDataUsecase getLeaderProfile,
    required GetLeaderFollowersUsecase getLeaderFollowers,
    required DeleteLeaderPostUsecase deleteLeaderPostUseCase,
    required FollowUnfollowLeaderUsecase followUnfollowLeaderUsecase,
    required GetLeaderPostsUsecase getPosts,
    required SaveUnsaveUseCase saveUnsaveUseCase,
    required LikeUnlikeUseCase likeUnlikeUseCase,
    required GetSocialUpdatesUseCase getSocialUpdatesUseCase,
  })  : _getLeaderProfile = getLeaderProfile,
        _deleteLeaderPostUsecase = deleteLeaderPostUseCase,
        _getLeaderFollowersUsecase = getLeaderFollowers,
        _followUnFollowLeaderUsecase = followUnfollowLeaderUsecase,
        _getLeaderPostsUsecase = getPosts,
        _getSocialUpdatesUseCase = getSocialUpdatesUseCase,
        _likeUnlikeUseCase = likeUnlikeUseCase,
        _saveUnsaveUseCase = saveUnsaveUseCase,
        super(const LeaderDashboardState()) {

    on<FetchLeaderDashboardData>(_onFetchProfileInitial);
    on<FetchMoreLeaderPosts>(_onFetchMorePosts);
    on<FetchLeaderFollowers>(_onFetchFollowers);
    on<FollowUnfollowLeaderEvent>(_toggleFollowUnfollowLeader);
    on<ToggleLikeEvent>(_toggleLike);
    on<ToggleSavePostEvent>(_savePost);
    on<DeleteLeaderPostEvent>(_deletePost);
    on<_OnSocialUpdateEvent>(_onSocialUpdate);

    _socialSubscription = _getSocialUpdatesUseCase().listen((update) {
      add(_OnSocialUpdateEvent(update: update));
    });
  }

  // Future<void> _onFetchProfileInitial(FetchLeaderDashboardData event, Emitter<LeaderDashboardState> emit) async {
  //   emit(state.copyWith(status: LeaderDashboardStatus.loading));
  //
  //   final results = await Future.wait([
  //     _getLeaderProfile(leaderId: event.leaderId),
  //     _getLeaderPostsUsecase(leaderId: event.leaderId, from: 0, to: pageSize - 1, postType: 'post'),
  //     _getLeaderPostsUsecase(leaderId: event.leaderId, from: 0, to: pageSize - 1, postType: 'reel'),
  //   ]);
  //
  //   final profileRes = results[0] as Either<Failure, LeaderEntity>;
  //   final postsRes = results[1] as Either<Failure, List<PostEntity>>;
  //   final reelsRes = results[2] as Either<Failure, List<PostEntity>>;
  //
  //   profileRes.fold(
  //         (failure) => emit(state.copyWith(status: LeaderDashboardStatus.failure)),
  //         (leader) {
  //           postsRes.fold(
  //             (f) => null, // Handle failure if needed
  //             (posts) {
  //               reelsRes.fold(
  //                 (f) => null,
  //                 (reels) => emit(state.copyWith(
  //                   status: LeaderDashboardStatus.loaded,
  //                   leader: leader,
  //                   posts: posts,
  //                   reels: reels,
  //                   hasMorePosts: posts.length == pageSize,
  //                   hasMoreReels: reels.length == pageSize,
  //             ),),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> _onFetchProfileInitial(FetchLeaderDashboardData event, Emitter<LeaderDashboardState> emit) async {
    emit(state.copyWith(status: LeaderDashboardStatus.loading));

    final results = await Future.wait([
      _getLeaderProfile(leaderId: event.leaderId),
      _getLeaderPostsUsecase(leaderId: event.leaderId, from: 0, to: pageSize - 1, postType: 'post'),
      _getLeaderPostsUsecase(leaderId: event.leaderId, from: 0, to: pageSize - 1, postType: 'reel'),
    ]);

    // Use dynamic here to avoid that Casting Error
    final profileRes = results[0] as Either<Failure, LeaderEntity>;
    final postsRes = results[1] as Either<Failure, List<PostEntity>>;
    final reelsRes = results[2] as Either<Failure, List<PostEntity>>;

    profileRes.fold(
          (failure) => emit(state.copyWith(status: LeaderDashboardStatus.failure, errorMessage: failure.message)),
          (leader) {
        // Posts handle karo
        (postsRes as Either).fold(
              (f) => emit(state.copyWith(status: LeaderDashboardStatus.failure)),
              (posts) {
            // Reels handle karo
            (reelsRes as Either).fold(
                  (f) => emit(state.copyWith(status: LeaderDashboardStatus.failure)),
                  (reels) {
                // Final Update
                emit(state.copyWith(
                  status: LeaderDashboardStatus.loaded,
                  leader: leader,
                  posts: posts as List<PostEntity>,
                  reels: reels as List<PostEntity>,
                  hasMorePosts: posts.length == pageSize,
                  hasMoreReels: reels.length == pageSize,
                ));
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onFetchMorePosts(FetchMoreLeaderPosts event, Emitter<LeaderDashboardState> emit) async {
    final bool hasMore = event.type == 'post' ? state.hasMorePosts : state.hasMoreReels;
    if (state.isFetchingMore || !hasMore) return;

    emit(state.copyWith(isFetchingMore: true));

    final int currentCount = event.type == 'post' ? state.posts.length : state.reels.length;

    final result = await _getLeaderPostsUsecase(
      leaderId: event.leaderId,
      from: currentCount,
      to: currentCount + pageSize - 1,
      postType: event.type,
    );

    result.fold(
          (failure) => emit(state.copyWith(isFetchingMore: false)),
          (newItems) {
        if (event.type == 'post') {
          emit(state.copyWith(
            posts: [...state.posts, ...newItems],
            isFetchingMore: false,
            hasMorePosts: newItems.length == pageSize,
          ));
        } else {
          emit(state.copyWith(
            reels: [...state.reels, ...newItems],
            isFetchingMore: false,
            hasMoreReels: newItems.length == pageSize,
          ));
        }
      },
    );
  }

  Future<void> _onFetchFollowers(FetchLeaderFollowers event, Emitter<LeaderDashboardState> emit) async {
    emit(state.copyWith(isFollowersLoading: true));

    final result = await _getLeaderFollowersUsecase(leaderId: event.leaderId);

    result.fold(
          (failure) => emit(state.copyWith(
        isFollowersLoading: false,
        status: LeaderDashboardStatus.failure,
        errorMessage: failure.message,
      )),
          (followers) => emit(state.copyWith(
        leaderFollowers: followers,
        isFollowersLoading: false,
      )),
    );
  }

  Future<void> _toggleLike(ToggleLikeEvent event, Emitter<LeaderDashboardState> emit) async {
    final originalPosts = List<PostEntity>.from(state.posts);

    final updatedPosts = state.posts.map((post) {
      if(post.id == event.postId){
        final isLiked = !post.isLiked;
        return (post as PostModel).copyWith(
          isLiked: isLiked,
          likesCount: isLiked ? post.likesCount + 1 : (post.likesCount > 0 ? post.likesCount - 1 : 0),
        );
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts, status: LeaderDashboardStatus.loaded));

    final result = await _likeUnlikeUseCase(postId:event.postId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          posts: originalPosts,
          status: LeaderDashboardStatus.failure,
          errorMessage: "Could not update like: ${failure.message}",
          errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
      (success) {},
    );
  }

  Future<void> _toggleFollowUnfollowLeader(FollowUnfollowLeaderEvent event, Emitter<LeaderDashboardState> emit) async {
    if (state.leader == null) return;

    final originalLeaderData = state.leader as LeaderModel;
    final bool isCurrentlyFollowing = originalLeaderData.isFollowing;

    final updatedLeaderData = originalLeaderData.copyWith(
      isFollowing: !isCurrentlyFollowing,
      followersCount: !isCurrentlyFollowing ? originalLeaderData.followersCount + 1 : (originalLeaderData.followersCount > 0 ? originalLeaderData.followersCount - 1 : 0),
    );

    emit(state.copyWith(leader: updatedLeaderData));

    final result = await _followUnFollowLeaderUsecase(event.leaderId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          leader: originalLeaderData,
          status: LeaderDashboardStatus.failure,
          errorMessage: "Could not update follow: ${failure.message}",
          errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ));
      },
      (success) {
        emit(state.copyWith(
          status: LeaderDashboardStatus.leaderActionSuccess,
          successActionMessage: !isCurrentlyFollowing ? "Followed!" : "Unfollowed!",
          successTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ));
      },
    );
  }

  Future<void> _savePost(ToggleSavePostEvent event, Emitter<LeaderDashboardState> emit) async {
    final originalPosts = List<PostEntity>.from(state.posts);
    final postIndex = state.posts.indexWhere((p) => p.id == event.postId);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final isSaved = !post.isSaved;


    // Optimistic Update
    final updatedPosts = state.posts.map((post) {
      return (post.id == event.postId) ? (post as PostModel).copyWith(isSaved: isSaved) : post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts, status: LeaderDashboardStatus.loaded));

    final result = await _saveUnsaveUseCase(postId: event.postId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            posts: originalPosts,
            status: LeaderDashboardStatus.failure,
            errorMessage: "Failed to save post: ${failure.message}",
            errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: LeaderDashboardStatus.leaderActionSuccess,
            successActionMessage: isSaved ? "Post saved successfully!" : "Post Unsaved!",
            successTimeStamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
    );
  }

  Future<void> _deletePost(DeleteLeaderPostEvent event, Emitter<LeaderDashboardState> emit) async{
    final originalPosts = List<PostEntity>.from(state.posts);
    final originalReels = List<PostEntity>.from(state.reels);

    List<PostEntity> updatedPosts = state.posts;
    List<PostEntity> updatedReels = state.reels;

    if (event.type == 'post') {
      updatedPosts = state.posts.where((p) => p.id != event.postId).toList();
    } else {
      updatedReels = state.reels.where((r) => r.id != event.postId).toList();
    }

    emit(state.copyWith(
        posts: updatedPosts,
        reels: updatedReels,
        status: LeaderDashboardStatus.loaded
    ));

    final result = await _deleteLeaderPostUsecase(postId: event.postId);

    result.fold(
      (failure) => emit(state.copyWith(
        posts: originalPosts,
        reels: originalReels,
        status: LeaderDashboardStatus.failure,
        errorMessage: "Delete fail: ${failure.message}",
      )),
      (success) => emit(state.copyWith(
        status: LeaderDashboardStatus.leaderActionSuccess,
        successActionMessage: "${event.type == 'post' ? 'Post' : 'Reel'} deleted!",
      )),
    );
  }

  void _onSocialUpdate(_OnSocialUpdateEvent event, Emitter<LeaderDashboardState> emit) {
    final update = event.update;
    final String postId = update['postId'];

    // Helper function to update a list of posts/reels
    List<PostEntity> updateList(List<PostEntity> list) {
      return list.map((item) {
        if (item.id == postId) {
          final model = item as PostModel;
          switch (update['type']) {
            case 'like_update':
              return model.copyWith(likesCount: update['newCount'], isLiked: update['isLiked']);
            case 'save_update':
              return model.copyWith(isSaved: update['isSaved']);
            case 'comment_added':
              return model.copyWith(commentsCount: item.commentsCount + 1);
            case 'comment_deleted':
              return model.copyWith(commentsCount: item.commentsCount > 0 ? item.commentsCount - 1 : 0);
            default:
              return item;
          }
        }
        return item;
      }).toList();
    }

    emit(state.copyWith(
      posts: updateList(state.posts),
      reels: updateList(state.reels),
      status: LeaderDashboardStatus.loaded,
    ));
  }

  @override
  Future<void> close() {
    _socialSubscription?.cancel();
    return super.close();
  }
}
