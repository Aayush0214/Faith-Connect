import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/authentication/domain/auth_repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Either<Failure, bool>> call() async {
    return await _authRepository.logout();
  }
}