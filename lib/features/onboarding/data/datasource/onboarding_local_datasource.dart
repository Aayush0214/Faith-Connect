import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service/domain/repository/local_storage_service.dart';

abstract interface class OnboardingLocalDataSource {
  Future<bool?> fetchStatus();
  Future<void> saveStatus();
  Future<void> saveSelectedRole(String role);
  Future<String?> fetchSelectedRole();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final LocalStorageService _localStorageService;

  OnboardingLocalDataSourceImpl({required LocalStorageService localStorageService}) : _localStorageService = localStorageService;

  @override
  Future<bool?> fetchStatus() async {
    return await _localStorageService.getBool(StorageKeys.isOnboardingCompleted) ?? false;
  }

  @override
  Future<void> saveStatus() async {
    await _localStorageService.setBool(StorageKeys.isOnboardingCompleted, true);
  }

  @override
  Future<String?> fetchSelectedRole() async {
    return await _localStorageService.getString(StorageKeys.selectedRole);
  }

  @override
  Future<void> saveSelectedRole(String role) async {
    return await _localStorageService.setString(StorageKeys.selectedRole, role);
  }

}