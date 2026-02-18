import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/get_selected_role.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/set_selected_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/get_onboarding_status.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/set_onboarding_status.dart';

part 'on_boarding_event.dart';

part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final SetSelectedRoleUseCase _setSelectedRoleUseCase;
  final GetSelectedRoleUseCase _getSelectedRoleUseCase;

  final SetOnboardingStatusUseCase _setOnboardingStatusUseCase;
  final GetOnboardingStatusUseCase _getOnboardingStatusUseCase;

  OnBoardingBloc({
    required SetSelectedRoleUseCase setSelectedRoleUseCase,
    required GetSelectedRoleUseCase getSelectedRoleUseCase,
    required SetOnboardingStatusUseCase setOnBoardingStatusUseCase,
    required GetOnboardingStatusUseCase getOnBoardingStatusUseCase,
  }) : _setOnboardingStatusUseCase = setOnBoardingStatusUseCase,
       _getOnboardingStatusUseCase = getOnBoardingStatusUseCase,
       _getSelectedRoleUseCase = getSelectedRoleUseCase,
       _setSelectedRoleUseCase = setSelectedRoleUseCase,
       super(OnBoardingInitial()) {
    on<OnBoardingEvent>((event, emit) {});

    on<FetchOnBoardingStatusEvent>(_fetchOnboardingStatus);
    on<OnPageChangedEvent>(_changeOnboardingPage);
    on<SetOnBoardingStatusEvent>(_completeOnboarding);
  }

  Future<void> _fetchOnboardingStatus(FetchOnBoardingStatusEvent event, Emitter<OnBoardingState> emit) async {
    await Future.delayed(const Duration(seconds: 4));
    final value = await _getOnboardingStatusUseCase();
    final userRole = await _getSelectedRoleUseCase();
    debugPrint("onboarding Value: $value");
    debugPrint("user role: $userRole");
    if (value == null || userRole == null) {
      emit(CurrentOnboardingState(isComplete: false, currentStep: 0, totalSteps: 3, role: null));
    } else {
      emit(CurrentOnboardingState(isComplete: value, currentStep: 0, totalSteps: 3, role: userRole));
    }
  }

  void _changeOnboardingPage(OnPageChangedEvent event, Emitter<OnBoardingState> emit) {
    if (state is! CurrentOnboardingState) return;

    final current = state as CurrentOnboardingState;

    final updated = current.copyWith(
      currentStep: event.pageIndex,
      isComplete: event.pageIndex >= current.totalSteps,
    );
    emit(updated);
  }

  Future<void> _completeOnboarding(SetOnBoardingStatusEvent event, Emitter<OnBoardingState> emit) async {
    if (state is! CurrentOnboardingState) return;
    final current = state as CurrentOnboardingState;
    final updated = current.copyWith(
      isComplete: true,
      role: event.role.toUpperCase(),
      currentStep: current.totalSteps - 1,
    );
    await _setOnboardingStatusUseCase();
    await _setSelectedRoleUseCase(role: event.role);
    emit(updated);
  }
}
