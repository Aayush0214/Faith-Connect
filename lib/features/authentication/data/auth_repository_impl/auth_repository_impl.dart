import '../../../../core/common/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exception_handler.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:faith_connect/core/common/entities/user_entity.dart';
import 'package:faith_connect/features/authentication/data/model/signup_request_model.dart';
import 'package:faith_connect/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:faith_connect/features/authentication/domain/auth_repository/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl({required AuthRemoteDatasource authRemoteDatasource}) : _authRemoteDatasource = authRemoteDatasource;

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    return await convertException(() async {
      return await _authRemoteDatasource.login(email, password);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signup(SignupRequestModel model) async {
    return await convertException(() async {
      final response =  await _authRemoteDatasource.signup(model);
      if (response.user == null) {
        throw const AuthException("User creation failed");
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
        fullName: response.user!.userMetadata?['full_name'] ?? 'No Name',
        role: response.user!.userMetadata?['role'] ?? 'worshiper',
        faith: response.user!.userMetadata?['faith'],
        bio: response.user!.userMetadata?['bio'],
        profilePhotoUrl: response.user!.userMetadata?['profile_photo_url'],
      );
    });
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    return await convertException(() async {
      return await _authRemoteDatasource.logout();
    });
  }
}