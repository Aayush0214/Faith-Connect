import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/worshipers/domain/entities/leader_entity.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/leader_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchExploreLeadersUsecase {
  final LeaderRepository _leaderRepository;

  FetchExploreLeadersUsecase({required LeaderRepository leaderRepository}): _leaderRepository = leaderRepository;

  Future<Either<Failure, List<LeaderEntity>>> call({required int from, required int to, String? searchQuery}) async{
    return await _leaderRepository.getExploreLeaders(from: from, to: to, searchQuery: searchQuery);
  }
}