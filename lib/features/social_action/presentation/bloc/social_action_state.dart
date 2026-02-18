part of 'social_action_bloc.dart';

@immutable
sealed class SocialActionState {}

class SocialActionInitial extends SocialActionState {}

class SocialActionLoading extends SocialActionState {}

class CommentsLoaded extends SocialActionState {
  final List<CommentEntity> comments;
  CommentsLoaded({required this.comments});
}

class SocialActionSuccess extends SocialActionState {
  final String message;

  SocialActionSuccess({this.message = ""});
}

class SocialActionFailure extends SocialActionState {
  final String error;

  SocialActionFailure({required this.error});
}
