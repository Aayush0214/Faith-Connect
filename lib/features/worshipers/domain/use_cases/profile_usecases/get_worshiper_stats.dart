import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/profile_repository.dart';

class FetchWorshiperStatsUsecase {
  final ProfileRepository _profileRepository;

  FetchWorshiperStatsUsecase({required ProfileRepository profileRepository}): _profileRepository = profileRepository;

  Future<Either<Failure, Map<String, int>>> call() async{
    return await _profileRepository.getWorshiperStats();
  }
}