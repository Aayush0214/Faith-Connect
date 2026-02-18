import 'package:faith_connect/features/worshipers/domain/repositories/reels_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/common/entities/post_entity.dart';

class GetReelsUsecase {
  final ReelsRepository _reelsRepository;
  GetReelsUsecase({required ReelsRepository reelRepository}): _reelsRepository = reelRepository;

  Future<Either<Failure, List<PostEntity>>> call({required int from, required int to}) async {
    return await _reelsRepository.getReels(from: from, to: to);
  }
}