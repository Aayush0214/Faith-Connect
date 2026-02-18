import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:faith_connect/features/worshipers/data/datasources/profile_remote_datasource.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/profile_repository.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource;

  ProfileRepositoryImpl({required ProfileRemoteDataSource profileRemoteDataSource}): _profileRemoteDataSource = profileRemoteDataSource;

  @override
  Future<Either<Failure, Map<String, int>>> getWorshiperStats() async{
    return convertException(() async{
      return _profileRemoteDataSource.getWorshiperStats();
    });
  }

}