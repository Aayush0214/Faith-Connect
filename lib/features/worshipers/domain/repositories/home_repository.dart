import 'package:faith_connect/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/post_entity.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, List<PostEntity>>> getExplorePosts({required int from, required int to});
  Future<Either<Failure, List<PostEntity>>> getFollowingPosts({required int from, required int to});
  Future<Either<Failure, List<PostEntity>>> getPostsByLeaderId(leaderId);
}