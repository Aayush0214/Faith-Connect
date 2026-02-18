import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/common/entities/comment_entity.dart';
import 'package:faith_connect/features/social_action/domain/repository/social_repository.dart';

class GetCommentUseCase {
  final SocialActionRepository _socialRepository;

  GetCommentUseCase({required SocialActionRepository socialRepository}) : _socialRepository = socialRepository;

  Future<Either<Failure, List<CommentEntity>>> call({required String postId}) async{
    return await _socialRepository.getComments(postId);
  }
}