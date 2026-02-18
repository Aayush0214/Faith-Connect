import 'package:faith_connect/features/social_action/domain/repository/social_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

class AddCommentUseCase {
  final SocialActionRepository _socialRepository;

  AddCommentUseCase({required SocialActionRepository socialRepository}) : _socialRepository = socialRepository;

  Future<Either<Failure, void>> call({required String postId, required String comment}) async{
    return await _socialRepository.handleAddComment(postId, comment);
  }
}