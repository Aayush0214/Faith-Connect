import 'package:fpdart/fpdart.dart';
import '../entities/leader_entity.dart';
import '../../../../core/error/failure.dart';

abstract interface class LeaderRepository {
  Future<Either<Failure, List<LeaderEntity>>> getExploreLeaders({required int from, required int to, String? searchQuery});
  Future<Either<Failure, List<LeaderEntity>>> getMyLeaders({required int from, required int to, String? searchQuery});
  Future<Either<Failure, void>> toggleFollow(String leaderId);
}