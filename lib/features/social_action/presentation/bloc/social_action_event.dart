part of 'social_action_bloc.dart';

@immutable
sealed class SocialActionEvent {}

class ToggleLikeEvent extends SocialActionEvent {
  final String postId;

  ToggleLikeEvent(this.postId);
}

class ToggleSaveEvent extends SocialActionEvent {
  final String postId;

  ToggleSaveEvent({required this.postId});
}

class FetchCommentsEvent extends SocialActionEvent {
  final String postId;

  FetchCommentsEvent({required this.postId});
}

class UpdateCommentsUIEvent extends SocialActionEvent{
  final List<CommentEntity> updatedComments;

  UpdateCommentsUIEvent({required this.updatedComments});
}

class AddCommentEvent extends SocialActionEvent {
  final String postId, comment;

  AddCommentEvent({required this.postId, required this.comment});
}

class DeleteCommentEvent extends SocialActionEvent {
  final String commentId, postId;

  DeleteCommentEvent({required this.commentId, required this.postId});
}
