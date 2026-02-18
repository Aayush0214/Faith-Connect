part of 'create_content_bloc.dart';

sealed class CreateContentState extends Equatable {
  const CreateContentState();

  @override
  List<Object> get props => [];
}

final class CreateContentInitial extends CreateContentState {}

class MediaPickingLoading extends CreateContentState {}

class MediaSelectedState extends CreateContentState {
  final File file;
  final String postType; // 'post' ya 'reel'
  const MediaSelectedState({required this.file, required this.postType});

  @override
  List<Object> get props => [file, postType];
}

class UploadingState extends CreateContentState {
  final double progress;
  final String message; // "Compressing..." ya "Uploading..."
  const UploadingState({required this.progress, required this.message});

  @override
  List<Object> get props => [progress, message];
}

class UploadSuccess extends CreateContentState {}

class CreateContentError extends CreateContentState {
  final String message;
  const CreateContentError(this.message);

  @override
  List<Object> get props => [message];
}
