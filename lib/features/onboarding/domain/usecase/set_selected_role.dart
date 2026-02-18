import 'package:faith_connect/features/onboarding/domain/repository/onboarding_repository.dart';

class SetSelectedRoleUseCase {
  final OnboardingRepository _onboardingRepository;

  SetSelectedRoleUseCase({required OnboardingRepository onboardingRepository}) : _onboardingRepository = onboardingRepository;

  Future<void> call({required String role}) async {
    return await _onboardingRepository.setSelectedRole(role);
  }
}