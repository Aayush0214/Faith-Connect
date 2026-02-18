import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/authentication/data/model/signup_request_model.dart';

import '../../../../core/common/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signup(SignupRequestModel model);
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, bool>> logout();
}