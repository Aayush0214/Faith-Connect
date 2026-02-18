import 'package:faith_connect/core/common/entities/post_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/dashboard_repository.dart';

class GetLeaderPostsUsecase {
  final LeaderDashboardRepository _dashboardRepository;

  GetLeaderPostsUsecase({required LeaderDashboardRepository dashboardRepository}): _dashboardRepository = dashboardRepository;

  Future<Either<Failure, List<PostEntity>>> call({required String leaderId, required int from, required int to, String? postType}) async{
    return await _dashboardRepository.getLeaderPosts(leaderId: leaderId, from: from, to: to, postType: postType);
  }
}