import '../repository/onboarding_repository.dart';

class GetSelectedRoleUseCase {
  final OnboardingRepository _onboardingRepository;

  GetSelectedRoleUseCase({required OnboardingRepository onboardingRepository}) : _onboardingRepository = onboardingRepository;

  Future<String?> call() async {
    return await _onboardingRepository.getSelectedRole();
  }
}