import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/leader_repository.dart';
import 'package:fpdart/fpdart.dart';

class FollowUnfollowLeaderUsecase {
  final LeaderRepository _leaderRepository;

  FollowUnfollowLeaderUsecase({required LeaderRepository leaderRepository}): _leaderRepository = leaderRepository;

  Future<Either<Failure, void>> call(String leaderId) async{
    return await _leaderRepository.toggleFollow(leaderId);
  }
}