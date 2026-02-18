part of 'create_content_bloc.dart';

sealed class CreateContentEvent extends Equatable {
  const CreateContentEvent();
  @override
  List<Object> get props => [];
}

class PickMediaEvent extends CreateContentEvent {
  final bool isVideo;
  const PickMediaEvent({required this.isVideo});

  @override
  List<Object> get props => [isVideo];
}

class UploadPostEvent extends CreateContentEvent {
  final String caption;
  const UploadPostEvent({required this.caption});

  @override
  List<Object> get props => [caption];
}

class ResetMediaEvent extends CreateContentEvent {}
