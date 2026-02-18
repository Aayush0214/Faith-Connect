import 'package:faith_connect/core/common/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/dashboard_repository.dart';

class GetLeaderFollowersUsecase {
  final LeaderDashboardRepository _dashboardRepository;

  GetLeaderFollowersUsecase({required LeaderDashboardRepository dashboardRepository}): _dashboardRepository = dashboardRepository;

  Future<Either<Failure, List<UserEntity>>> call({required String leaderId}) async{
    return await _dashboardRepository.getLeaderFollowersList(leaderId: leaderId);
  }
}