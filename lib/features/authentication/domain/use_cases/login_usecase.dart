import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/authentication/domain/auth_repository/auth_repository.dart';
import 'package:faith_connect/core/common/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Either<Failure, UserEntity>> call({required String email, required String password}) async {
    return await _authRepository.login(email, password);
  }
}