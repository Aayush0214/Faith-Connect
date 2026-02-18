import 'package:fpdart/fpdart.dart';
import '../../../../core/common/entities/user_entity.dart';
import '../../../../core/error/failure.dart';
import '../auth_repository/auth_repository.dart';
import 'package:faith_connect/features/authentication/data/model/signup_request_model.dart';

class SignupUseCase {
  final AuthRepository _authRepository;

  SignupUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Either<Failure, UserEntity>> call({required SignupRequestModel model}) async {
    return await _authRepository.signup(model);
  }
}