import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/core/common/entities/post_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/entities/comment_entity.dart';
import '../../../../../../core/common/models/post_model.dart';
import '../../../../../social_action/domain/usecases/get_social_update_usecase.dart';
import '../../../../../social_action/domain/usecases/like_unlike_usecase.dart';
import '../../../../../social_action/domain/usecases/save_unsave_usecase.dart';
import '../../../../domain/use_cases/reel_usecase/reel_usecase.dart';

part 'reels_event.dart';
part 'reels_state.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final int pageSize = 5;
  final GetReelsUsecase _getReelsUsecase;
  final LikeUnlikeUseCase _likeUnlikeUseCase;
  final SaveUnsaveUseCase _saveUnsaveUseCase;
  final GetSocialUpdatesUseCase _getSocialUpdatesUseCase;
  StreamSubscription? _socialSubscription;

  ReelsBloc({
    required GetReelsUsecase getReelsUsecase,
    required LikeUnlikeUseCase toggleLikeUsecase,
    required SaveUnsaveUseCase toggleSavePostUsecase,
    required GetSocialUpdatesUseCase getSocialUpdatesUseCase,
  })
      : _getReelsUsecase = getReelsUsecase,
        _likeUnlikeUseCase = toggleLikeUsecase,
        _saveUnsaveUseCase = toggleSavePostUsecase,
        _getSocialUpdatesUseCase = getSocialUpdatesUseCase,
        super(ReelsState(reels: [])) {
    on<FetchReelsEvent>(_onFetchReels);
    on<FetchMoreReels>(_onFetchMoreReels);
    on<ToggleLikeReel>(_onToggleReelLike);
    on<ToggleSaveReel>(_onToggleReelSave);
    on<_OnSocialUpdateEvent>(_onSocialUpdate);

    _socialSubscription = _getSocialUpdatesUseCase().listen((update) {
      add(_OnSocialUpdateEvent(update: update));
    });
  }

  Future<void> _onFetchReels(FetchReelsEvent event, Emitter<ReelsState> emit) async {
    emit(state.copyWith(status: ReelsStatus.reelLoading));
    final result = await _getReelsUsecase(from: 0, to: pageSize - 1);
    result.fold(
      (failure) => emit(state.copyWith(status: ReelsStatus.reelError, errorActionMessage: failure.message, errorTimeStamp: DateTime.now().millisecondsSinceEpoch)),
      (reels) {
        emit(state.copyWith(
          status: ReelsStatus.reelLoaded,
          reels: reels,
          postComments: [],
          hasMoreData: reels.length == pageSize,
          successTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ));
      }
    );
  }

  Future<void> _onFetchMoreReels(FetchMoreReels event, Emitter<ReelsState> emit) async {
    if (state.isFetchingMore || !state.hasMoreData) return;

    emit(state.copyWith(isFetchingMore: true));

    final int from = state.reels.length;
    final int to = from + pageSize - 1;

    final result = await _getReelsUsecase(from: from, to: to);

    result.fold(
      (failure) {
        emit(state.copyWith(
            isFetchingMore: false,
            errorActionMessage: "Could not load more reels: ${failure.message}",
            errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ));
      },
      (newReels) {
        final reachedMax = newReels.length < pageSize;
        emit(state.copyWith(
          status: ReelsStatus.reelLoaded,
          reels: [...state.reels, ...newReels],
          isFetchingMore: false,
          hasMoreData: !reachedMax,
        ));
      },
    );
  }

  void _onSocialUpdate(_OnSocialUpdateEvent event, Emitter<ReelsState> emit) {
    final update = event.update;
    final String postId = update['postId'];

    final updatedPosts = state.reels.map((reel) {
      if (reel.id == postId) {
        final model = reel as PostModel;
        switch (update['type']) {
          case 'like_update':
            return model.copyWith(likesCount: update['newCount'], isLiked: update['isLiked']);
          case 'save_update':
            return model.copyWith(isSaved: update['isSaved']);
          case 'comment_added':
            return model.copyWith(commentsCount: reel.commentsCount + 1);
          case 'comment_deleted':
            return model.copyWith(commentsCount: reel.commentsCount > 0 ? reel.commentsCount - 1 : 0);
          default: return reel;
        }
      }
      return reel;
    }).toList();

    emit(state.copyWith(reels: updatedPosts, status: ReelsStatus.reelLoaded));
  }

  Future<void> _onToggleReelLike(ToggleLikeReel event, Emitter<ReelsState> emit) async {
    final originalReels = List<PostEntity>.from(state.reels);

    // OPTIMISTIC UPDATE
    final updatedReels = state.reels.map((reel) {
      if (reel.id == event.reelId) {
        final isLiked = !reel.isLiked;
        return (reel as PostModel).copyWith(
          isLiked: isLiked,
          likesCount: isLiked ? reel.likesCount + 1 : reel.likesCount > 0 ? reel.likesCount - 1 : 0,
        );
      }
      return reel;
    }).toList();

    emit(state.copyWith(reels: updatedReels, status: ReelsStatus.reelLoaded));

    final result = await _likeUnlikeUseCase(postId: event.reelId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          reels: originalReels,
          status: ReelsStatus.reelError,
          errorActionMessage: "Failed to like: ${failure.message}",
          errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
      (success) {},
    );
  }

  Future<void> _onToggleReelSave(ToggleSaveReel event, Emitter<ReelsState> emit) async {
    final originalReels = List<PostEntity>.from(state.reels);
    final reel = state.reels.firstWhere((reel) => reel.id == event.reelId);
    final isSaved = !reel.isSaved;

    // OPTIMISTIC UPDATE
    final updatedReels = state.reels.map((reel) {
      return reel.id == event.reelId ? (reel as PostModel).copyWith(isSaved: isSaved) : reel;
    }).toList();

    emit(state.copyWith(reels: updatedReels));

    final result = await _saveUnsaveUseCase(postId: event.reelId);
    result.fold(
      (failure){
        emit(
          state.copyWith(
            reels: originalReels,
            status: ReelsStatus.reelError,
            errorActionMessage: "Failed to save: ${failure.message}",
            errorTimeStamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: ReelsStatus.reelActionSuccess,
            successActionMessage: isSaved ? "Post saved successfully!" : "Post Unsaved!",
            successTimeStamp: DateTime.now().millisecondsSinceEpoch,
          )
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
