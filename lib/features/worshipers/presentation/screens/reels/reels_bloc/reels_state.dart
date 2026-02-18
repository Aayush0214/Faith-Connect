part of 'reels_bloc.dart';

enum ReelsStatus {
  initial,
  reelLoading,
  reelLoaded,
  reelError,
  reelActionSuccess,
  commentsLoading,
  commentsLoaded,
  commentError,
  commentActionSuccess,
}

class ReelsState extends Equatable{
  final List<PostEntity> reels;
  final List<CommentEntity> postComments;
  final ReelsStatus status;
  final String errorActionMessage;
  final String successActionMessage;
  final int errorTimeStamp;
  final int successTimeStamp;
  final bool isFetchingMore;
  final bool hasMoreData;

  const ReelsState({
    required this.reels,
    this.postComments = const [],
    this.status = ReelsStatus.initial,
    this.errorActionMessage = '',
    this.isFetchingMore = false,
    this.hasMoreData = true,
    this.errorTimeStamp = 0,
    this.successActionMessage = '',
    this.successTimeStamp = 0,
  });

  ReelsState copyWith({
    List<PostEntity>? reels,
    List<CommentEntity>? postComments,
    ReelsStatus? status,
    String? errorActionMessage,
    bool? isFetchingMore,
    bool? hasMoreData,
    int? errorTimeStamp,
    int? successTimeStamp,
    String? successActionMessage,
  }) {
    return ReelsState(
      reels: reels ?? this.reels,
      postComments: postComments ?? this.postComments,
      status: status ?? this.status,
      errorActionMessage: errorActionMessage ?? this.errorActionMessage,
      successActionMessage: successActionMessage ?? this.successActionMessage,
      errorTimeStamp: errorTimeStamp ?? this.errorTimeStamp,
      successTimeStamp: successTimeStamp ?? this.successTimeStamp,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  @override
  List<Object?> get props => [
    reels,
    postComments,
    status,
    errorActionMessage,
    isFetchingMore,
    hasMoreData,
    errorTimeStamp,
    successTimeStamp,
    successActionMessage,
  ];
}