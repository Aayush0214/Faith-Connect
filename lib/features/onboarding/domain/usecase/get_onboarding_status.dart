import '../repository/onboarding_repository.dart';

class GetOnboardingStatusUseCase {
  final OnboardingRepository _repository;

  GetOnboardingStatusUseCase({required OnboardingRepository repository}) : _repository = repository;

  Future<bool?> call() async {
    return await _repository.getOnboardingStatus();
  }
}