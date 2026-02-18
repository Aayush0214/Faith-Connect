import 'package:faith_connect/features/social_action/domain/repository/social_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

class LikeUnlikeUseCase {
  final SocialActionRepository _socialRepository;

  LikeUnlikeUseCase({required SocialActionRepository socialRepository}) : _socialRepository = socialRepository;

  Future<Either<Failure, void>> call({required String postId}) async{
    return await _socialRepository.handleLike(postId);
  }
}