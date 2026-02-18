import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/social_action/domain/usecases/get_social_update_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/like_unlike_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/save_unsave_usecase.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/home_usecases/get_home_following_posts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/models/post_model.dart';
import '../../../../../../core/common/entities/post_entity.dart';
import '../../../../domain/use_cases/home_usecases/get_home_explore_posts.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final int pageSize = 5;
  final GetHomeExplorePostUsecase _getHomeExplorePostUsecase;
  final GetHomeFollowingPostUsecase _getHomeFollowingPostUsecase;
  final LikeUnlikeUseCase _likeUnlikeUseCase;
  final SaveUnsaveUseCase _saveUnsaveUseCase;
  final GetSocialUpdatesUseCase _getSocialUpdatesUseCase;
  StreamSubscription? _socialSubscription;

  HomeBloc({
    required SaveUnsaveUseCase saveUnsaveUseCase,
    required LikeUnlikeUseCase likeUnlikeUseCase,
    required GetSocialUpdatesUseCase getSocialUpdatesUseCase,
    required GetHomeExplorePostUsecase explorePostUsecase,
    required GetHomeFollowingPostUsecase followingPostUsecase,
  }) : _getHomeFollowingPostUsecase = followingPostUsecase,
       _getHomeExplorePostUsecase = explorePostUsecase,
       _getSocialUpdatesUseCase = getSocialUpdatesUseCase,
       _likeUnlikeUseCase = likeUnlikeUseCase,
       _saveUnsaveUseCase = saveUnsaveUseCase,
       super(HomeState(posts: [])) {

    on<ToggleLikeEvent>(_toggleLike);
    on<ToggleSavePostEvent>(_savePost);
    on<FetchExplorePosts>(_fetchExplorePosts);
    on<FetchFollowingPosts>(_fetchFollowingPosts);
    on<FetchMoreHomePosts>(_fetchMoreHomePosts);
    on<_OnSocialUpdateEvent>(_onSocialUpdate);

    _socialSubscription = _getSocialUpdatesUseCase().listen((update) {
      add(_OnSocialUpdateEvent(update: update));
    });
  }

  Future<void> _fetchExplorePosts(FetchExplorePosts event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.homeLoading));
    final result = await _getHomeExplorePostUsecase(from: 0, to: pageSize - 1);
    result.fold(
      (failure) => emit(state.copyWith(status: HomeStatus.homeError, errorActionMessage: failure.message, errorTimeStamp: DateTime.now().millisecondsSinceEpoch)),
      (posts) => emit(state.copyWith(status: HomeStatus.homeLoaded, posts: posts, hasMoreData: posts.length == pageSize, successTimeStamp: DateTime.now().millisecondsSinceEpoch)),
    );
  }

  Future<void> _fetchFollowingPosts(FetchFollowingPosts event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.homeLoading));
    final result = await _getHomeFollowingPostUsecase(from: 0, to: pageSize - 1);
    result.fold(
      (failure) => emit(state.copyWith(status: HomeStatus.homeError, errorActionMessage: failure.message, errorTimeStamp: DateTime.now().millisecondsSinceEpoch)),
      (posts) => emit(state.copyWith(status: HomeStatus.homeLoaded, posts: posts, hasMoreData: posts.length == pageSize, successTimeStamp: DateTime.now().millisecondsSinceEpoch)),
    );
  }

  Future<void> _fetchMoreHomePosts(FetchMoreHomePosts event, Emitter<HomeState> emit) async {
    if (state.isFetchingMore || !state.hasMoreData) return;

    emit(state.copyWith(isFetchingMore: true));

    final int from = state.posts.length;
    final int to = from + pageSize - 1;

    final result = event.isExplore ? await _getHomeExplorePostUsecase(from: from, to: to) : await _getHomeFollowingPostUsecase(from: from, to: to);

    result.fold(
      (failure){
        emit(state.copyWith(status: HomeStatus.homeError, isFetchingMore: false, errorActionMessage: failure.message, errorTimeStamp: DateTime.now().millisecondsSinceEpoch));
      },
      (newPosts){
        final reachedMax = newPosts.length < pageSize;
        emit(state.copyWith(status: HomeStatus.homeLoaded, posts: [...state.posts, ...newPosts], isFetchingMore: false, hasMoreData: !reachedMax));
      },
    );
  }

  void _onSocialUpdate(_OnSocialUpdateEvent event, Emitter<HomeState> emit) {
    final update = event.update;
    final String postId = update['postId'];

    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        final model = post as PostModel;
        switch (update['type']) {
          case 'like_update':
            return model.copyWith(likesCount: update['newCount'], isLiked: update['isLiked']);
          case 'save_update':
            return model.copyWith(isSaved: update['isSaved']);
          case 'comment_added':
            return model.copyWith(commentsCount: post.commentsCount + 1);
          case 'comment_deleted':
            return model.copyWith(commentsCount: post.commentsCount > 0 ? post.commentsCount - 1 : 0);
          default: return post;
        }
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts, status: HomeStatus.homeLoaded));
  }

  Future<void> _toggleLike(ToggleLikeEvent event, Emitter<HomeState> emit) async {
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

    emit(state.copyWith(posts: updatedPosts, status: HomeStatus.homeLoaded));

    final result = await _likeUnlikeUseCase(postId:event.postId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          posts: originalPosts,
          status: HomeStatus.homeError,
          errorActionMessage: "Could not update like: ${failure.message}",
          errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
      (success) {},
    );
  }

  Future<void> _savePost(ToggleSavePostEvent event, Emitter<HomeState> emit) async {
    final originalPosts = List<PostEntity>.from(state.posts);
    final postIndex = state.posts.indexWhere((p) => p.id == event.postId);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final isSaved = !post.isSaved;


    // Optimistic Update
    final updatedPosts = state.posts.map((post) {
      return (post.id == event.postId) ? (post as PostModel).copyWith(isSaved: isSaved) : post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts, status: HomeStatus.homeLoaded));

    final result = await _saveUnsaveUseCase(postId: event.postId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            posts: originalPosts,
            status: HomeStatus.homeError,
            errorActionMessage: "Failed to save post: ${failure.message}",
            errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: HomeStatus.homeActionSuccess,
            successActionMessage: isSaved ? "Post saved successfully!" : "Post Unsaved!",
            successTimeStamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _socialSubscription?.cancel();
    return super.close();
  }
}
