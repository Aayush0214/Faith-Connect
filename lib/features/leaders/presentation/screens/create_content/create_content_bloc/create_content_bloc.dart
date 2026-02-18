import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/leaders/data/models/upload_post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../../../core/services/media_service/media_service.dart';
import '../../../../domain/usecases/create_content_usecases/create_content_usecase.dart';

part 'create_content_event.dart';

part 'create_content_state.dart';

class CreateContentBloc extends Bloc<CreateContentEvent, CreateContentState> {
  final MediaService _mediaService;
  final CreateContentUsecase _createContentUsecase;

  File? _selectedFile;
  String? _detectedType;

  CreateContentBloc({
    required MediaService mediaService,
    required CreateContentUsecase createContentUsecase,
  }) : _mediaService = mediaService,
        _createContentUsecase = createContentUsecase,
        super(CreateContentInitial()) {
    on<PickMediaEvent>(_pickMediaFromGallery);
    on<UploadPostEvent>(_uploadPost);
    on<ResetMediaEvent>(_resetMedia);
  }

  Future<void> _pickMediaFromGallery(PickMediaEvent event, Emitter<CreateContentState> emit) async {
    File? file = event.isVideo
        ? await _mediaService.pickVideoFromGallery()
        : await _mediaService.pickImageFromGallery();

    if (file != null) {
      _selectedFile = file;
      _detectedType = event.isVideo ? 'reel' : 'post';
      emit(MediaSelectedState(file: _selectedFile!, postType: _detectedType!));
    }
  }

  Future<void> _uploadPost(UploadPostEvent event, Emitter<CreateContentState> emit) async {
    if (_selectedFile == null) return;

    try {
      File finalMedia = _selectedFile!;
      File? thumbFile;
      int? durationInSeconds;

      // --- STAGE 1: COMPRESSION ---
      if (_detectedType == 'reel') {
        emit(const UploadingState(progress: 0.1, message: "Compressing Video..."));

        final info = await VideoCompress.compressVideo(
          _selectedFile!.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
        );

        if (info != null && info.file != null) {
          finalMedia = info.file!;
          durationInSeconds = (info.duration! / 1000).round();
        }

        emit(const UploadingState(progress: 0.3, message: "Generating Thumbnail..."));
        thumbFile = await VideoCompress.getFileThumbnail(_selectedFile!.path);
      }

      // --- STAGE 2: UPLOADING (Simulation for UI) ---
      emit(const UploadingState(progress: 0.5, message: "Uploading to Cloud..."));

      final model = UploadPostModel(
        media: finalMedia,
        thumbnail: thumbFile,
        caption: event.caption,
        postType: _detectedType!,
        duration: durationInSeconds,
      );

      final result = await _createContentUsecase(model);

      result.fold(
        (failure){
          VideoCompress.cancelCompression();
          emit(CreateContentError(failure.message));
        },
        (success){
          VideoCompress.deleteAllCache(); // Cache saaf karo
          VideoCompress.cancelCompression();
          emit(UploadSuccess());
        },
      );
    } catch (e) {
      VideoCompress.cancelCompression();
      emit(CreateContentError("Process Failed: ${e.toString()}"));
    }
  }

  void _resetMedia(ResetMediaEvent event, Emitter<CreateContentState> emit) {
    _selectedFile = null;
    _detectedType = null;
    emit(CreateContentInitial());
  }

  @override
  Future<void> close() {
    VideoCompress.cancelCompression();
    return super.close();
  }
}
