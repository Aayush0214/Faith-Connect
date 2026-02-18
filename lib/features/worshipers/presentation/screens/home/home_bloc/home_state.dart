part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  homeLoading,
  homeLoaded,
  homeError,
  homeActionSuccess,
  commentsLoading,
  commentsLoaded,
  commentError,
  commentActionSuccess,
}

class HomeState extends Equatable {
  final List<PostEntity> posts;
  final HomeStatus status;
  final String successActionMessage;
  final String errorActionMessage;
  final int errorTimeStamp;
  final int successTimeStamp;
  final bool isFetchingMore;
  final bool hasMoreData;

  const HomeState({
    required this.posts,
    this.successActionMessage = '',
    this.errorActionMessage = '',
    this.errorTimeStamp = 0,
    this.successTimeStamp = 0,
    this.status = HomeStatus.initial,
    this.isFetchingMore = false,
    this.hasMoreData = true,

  });

  // copyWith method jo purani values ko preserve rakhega
  HomeState copyWith({
    List<PostEntity>? posts,
    String? successActionMessage,
    String? errorActionMessage,
    int? successTimeStamp,
    int? errorTimeStamp,
    HomeStatus? status,
    bool? isFetchingMore,
    bool? hasMoreData,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      successActionMessage: successActionMessage ?? this.successActionMessage,
      errorActionMessage: errorActionMessage ?? this.errorActionMessage,
      errorTimeStamp: errorTimeStamp ?? this.errorTimeStamp,
      successTimeStamp: successTimeStamp ?? this.successTimeStamp,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  @override
  List<Object?> get props => [posts, successActionMessage, errorActionMessage, errorTimeStamp, successTimeStamp, status, isFetchingMore, hasMoreData];
}