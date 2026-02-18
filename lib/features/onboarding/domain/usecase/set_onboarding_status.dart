import '../repository/onboarding_repository.dart';

class SetOnboardingStatusUseCase {
  final OnboardingRepository _onboardingRepository;

  SetOnboardingStatusUseCase({required OnboardingRepository repository}) : _onboardingRepository = repository;

  Future<void> call() async{
    await _onboardingRepository.saveOnboardingStatus();
  }

}