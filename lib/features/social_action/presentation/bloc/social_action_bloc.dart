import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faith_connect/core/common/entities/comment_entity.dart';
import 'package:faith_connect/features/social_action/domain/usecases/add_comment_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/like_unlike_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/save_unsave_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/get_comments_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/delete_comment_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/get_social_update_usecase.dart';

part 'social_action_event.dart';
part 'social_action_state.dart';

class SocialActionBloc extends Bloc<SocialActionEvent, SocialActionState> {
  final LikeUnlikeUseCase _likeUnlikeUseCase;
  final SaveUnsaveUseCase _saveUnsaveUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final GetCommentUseCase _getCommentsUsecase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final GetSocialUpdatesUseCase _getSocialUpdatesUseCase;
  StreamSubscription? _socialUpdatesSubscription;

  List<CommentEntity> _comments = [];

  SocialActionBloc({
    required LikeUnlikeUseCase likeUnlikeUseCase,
    required SaveUnsaveUseCase saveUnsaveUseCase,
    required AddCommentUseCase addCommentUseCase,
    required GetCommentUseCase getCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
    required GetSocialUpdatesUseCase getSocialUpdatesUseCase,
  }) : _likeUnlikeUseCase = likeUnlikeUseCase,
       _saveUnsaveUseCase = saveUnsaveUseCase,
       _addCommentUseCase = addCommentUseCase,
       _getCommentsUsecase = getCommentUseCase,
       _deleteCommentUseCase = deleteCommentUseCase,
       _getSocialUpdatesUseCase = getSocialUpdatesUseCase,
       super(SocialActionInitial()) {

    _socialUpdatesSubscription = _getSocialUpdatesUseCase().listen((update) {
      if (update['type'] == 'comment_added') {
        _comments.insert(0, update['comment']); // Top par add karo
        add(UpdateCommentsUIEvent(updatedComments: List.from(_comments)));
      } else if (update['type'] == 'comment_deleted') {
        _comments.removeWhere((c) => c.id == update['commentId']);
        add(UpdateCommentsUIEvent(updatedComments: List.from(_comments)));
      }
    });

    on<ToggleLikeEvent>((event, emit) async {
      final result = await _likeUnlikeUseCase(postId: event.postId);
      result.fold(
        (failure) => emit(SocialActionFailure(error: failure.message)),
        (_) => null,
      );
    });

    on<ToggleSaveEvent>((event, emit) async {
      final result = await _saveUnsaveUseCase(postId: event.postId);
      result.fold(
        (failure) => emit(SocialActionFailure(error: failure.message)),
        (_) => null,
      );
    });

    on<FetchCommentsEvent>((event, emit) async {
      emit(SocialActionLoading());
      final result = await _getCommentsUsecase(postId: event.postId);
      result.fold(
        (failure) => emit(SocialActionFailure(error: failure.message)),
        (comments) {
          _comments = comments;
          emit(CommentsLoaded(comments: comments));
        },
      );
    });

    on<UpdateCommentsUIEvent>((event, emit) {
      emit(CommentsLoaded(comments: event.updatedComments));
    });

    on<AddCommentEvent>((event, emit) async {
      final result = await _addCommentUseCase(postId: event.postId, comment: event.comment);
      result.fold(
        (failure) => emit(SocialActionFailure(error: failure.message)),
        (_) => emit(SocialActionSuccess(message: "Comment added successfully")),
      );
    });

    on<DeleteCommentEvent>((event, emit) async {
      final result = await _deleteCommentUseCase(commentId: event.commentId, postId: event.postId);
      result.fold(
        (failure) => emit(SocialActionFailure(error: failure.message)),
        (_) => emit(SocialActionSuccess(message: "Comment deleted successfully")),
      );
    });
  }

  @override
  Future<void> close() {
    _socialUpdatesSubscription?.cancel();
    return super.close();
  }
}
