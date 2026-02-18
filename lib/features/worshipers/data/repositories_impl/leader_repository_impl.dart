import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/worshipers/data/models/leader_model.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/leader_repository.dart';
import 'package:faith_connect/features/worshipers/data/datasources/leader_remote_datasource.dart';

class LeaderRepositoryImpl implements LeaderRepository {
  final LeaderRemoteDataSource _leaderRemoteDataSource;

  LeaderRepositoryImpl({required LeaderRemoteDataSource leaderRemoteDataSource}): _leaderRemoteDataSource = leaderRemoteDataSource;

  @override
  Future<Either<Failure, List<LeaderModel>>> getExploreLeaders({required int from, required int to, String? searchQuery}) async{
    return await convertException(() async {
      return await _leaderRemoteDataSource.getExploreLeaders(from: from, to: to, searchQuery: searchQuery);
    });
  }

  @override
  Future<Either<Failure, List<LeaderModel>>> getMyLeaders({required int from, required int to, String? searchQuery}) async{
    return await convertException(() async {
      return await _leaderRemoteDataSource.getMyLeaders(from: from, to: to, searchQuery: searchQuery);
    });
  }

  @override
  Future<Either<Failure, void>> toggleFollow(String leaderId) async{
    return await convertException(() async {
      return await _leaderRemoteDataSource.toggleFollowUnfollow(leaderId);
    });
  }
}