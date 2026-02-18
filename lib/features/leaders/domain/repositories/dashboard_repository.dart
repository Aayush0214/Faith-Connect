import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/worshipers/domain/entities/leader_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/post_entity.dart';
import '../../../../core/common/entities/user_entity.dart';

abstract interface class LeaderDashboardRepository {
  Future<Either<Failure, List<PostEntity>>> getLeaderPosts({required String leaderId, required int from, required int to, String? postType});
  Future<Either<Failure, List<UserEntity>>> getLeaderFollowersList({required String leaderId});
  Future<Either<Failure, LeaderEntity>> getLeaderProfileData({required String leaderId});
  Future<Either<Failure, void>> deletePost({required String postId});
}