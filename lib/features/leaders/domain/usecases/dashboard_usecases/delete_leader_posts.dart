import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/leaders/domain/repositories/dashboard_repository.dart';

class DeleteLeaderPostUsecase {
  final LeaderDashboardRepository _dashboardRepository;

  DeleteLeaderPostUsecase({required LeaderDashboardRepository dashboardRepository}): _dashboardRepository = dashboardRepository;

  Future<Either<Failure, void>> call({required String postId}) async{
    return await _dashboardRepository.deletePost(postId: postId);
  }
}