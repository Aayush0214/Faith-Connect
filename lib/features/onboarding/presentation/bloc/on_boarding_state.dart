part of 'on_boarding_bloc.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();
}

final class OnBoardingInitial extends OnBoardingState {
  @override
  List<Object> get props => [];
}

class CurrentOnboardingState extends OnBoardingState {
  final bool isComplete;
  final int currentStep;
  final int totalSteps;
  final String? role;


  const CurrentOnboardingState({
    required this.role,
    required this.isComplete,
    required this.currentStep,
    required this.totalSteps,
  });

  CurrentOnboardingState copyWith({
    bool? isComplete,
    int? currentStep,
    int? totalSteps,
    String? role,
  }) {
    return CurrentOnboardingState(
      role: role ?? this.role,
      isComplete: isComplete ?? this.isComplete,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
    );
  }

  @override
  List<Object?> get props => [isComplete, currentStep, totalSteps, role];
}
