abstract interface class OnboardingRepository {
  Future<bool?> getOnboardingStatus();
  Future<void> saveOnboardingStatus();
  Future<String?> getSelectedRole();
  Future<void> setSelectedRole(String role);
}