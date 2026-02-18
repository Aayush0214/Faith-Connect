import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/core/common/entities/user_entity.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/signup_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/media_service/media_service.dart';
import '../../../../data/model/signup_request_model.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final MediaService _mediaService;
  final SignupUseCase _signupUseCase;

  SignupBloc({
    required MediaService mediaService,
    required SignupUseCase signupUsecase,
  }) : _mediaService = mediaService,
       _signupUseCase = signupUsecase,
       super(SignupState()) {
    on<SignupEvent>((event, emit) {});

    on<SignupGalleryImageRequested>(_onGalleryRequested);
    on<SignupCameraImageRequested>(_onCameraRequested);
    on<SignupNameChanged>(_onSignupNameChanged);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupRoleChanged>(_onRoleChanged);
    on<SignupFaithChanged>(_onFaithChanged);
    on<SignupBioChanged>(_onBioChanged);
    on<SignupPasswordVisibilityToggled>(_onPasswordToggleVisibility);
    on<SignupSubmitted>(_onSubmitted);
  }

  void _onSignupNameChanged(SignupNameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(fullName: event.fullName));
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(SignupPasswordChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onRoleChanged(SignupRoleChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(role: event.role));
  }

  void _onPasswordToggleVisibility(SignupPasswordVisibilityToggled event, Emitter<SignupState> emit) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onFaithChanged(SignupFaithChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(faith: event.faith));
  }

  void _onBioChanged(SignupBioChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(bio: event.bio));
  }

  void _onSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    if (!state.isValidSignupForm) {
      emit(state.copyWith(status: SignupStatus.failure, failureTimeStamp: DateTime.now().millisecondsSinceEpoch, errorMessage: "Invalid Form"));
      return;
    }

    emit(state.copyWith(status: SignupStatus.loading));

    final requestData = SignupRequestModel(
      profilePhoto: state.profileImage,
      fullName: state.fullName,
      email: state.email,
      password: state.password,
      role: state.role,
      faith: state.faith,
      bio: state.bio,
    );

    final response = await _signupUseCase(model: requestData);

    response.fold(
      (failure) {
        debugPrint("error: ${failure.message}");
        emit(state.copyWith(status: SignupStatus.failure, errorMessage: failure.message, failureTimeStamp: DateTime.now().millisecondsSinceEpoch));
      },
      (user) => emit(state.copyWith(status: SignupStatus.success, user: user)),
    );
  }

  Future<void> _onGalleryRequested(SignupGalleryImageRequested event, Emitter<SignupState> emit) async {
    final pickedFile = await _mediaService.pickImageFromGallery();
    if (pickedFile != null) {
      final croppedImage = await _mediaService.cropProfileImage(pickedFile);
      if (croppedImage != null) {
        emit(state.copyWith(profileImage: croppedImage));
      }
    }
  }

  Future<void> _onCameraRequested(SignupCameraImageRequested event, Emitter<SignupState> emit) async {
    final clickedFile = await _mediaService.pickImageFromCamera();
    if (clickedFile != null) {
      final croppedImage = await _mediaService.cropProfileImage(clickedFile);
      if (croppedImage != null) {
        emit(state.copyWith(profileImage: croppedImage));
      }
    }
  }
}
