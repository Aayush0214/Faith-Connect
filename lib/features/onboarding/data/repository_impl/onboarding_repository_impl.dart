import '../datasource/onboarding_local_datasource.dart';
import '../../domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  OnboardingRepositoryImpl({
    required OnboardingLocalDataSource dataSource,
  }) : _localDataSource = dataSource;

  @override
  Future<bool?> getOnboardingStatus() async {
    return await _localDataSource.fetchStatus();
  }

  @override
  Future<void> saveOnboardingStatus() async {
    await _localDataSource.saveStatus();
  }

  @override
  Future<String?> getSelectedRole() async {
    return await _localDataSource.fetchSelectedRole();
  }

  @override
  Future<void> setSelectedRole(String role) async {
    return await _localDataSource.saveSelectedRole(role);
  }
}
