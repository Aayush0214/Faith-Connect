import 'package:faith_connect/features/worshipers/domain/entities/leader_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/leaders/domain/repositories/dashboard_repository.dart';

class GetLeaderProfileDataUsecase {
  final LeaderDashboardRepository _dashboardRepository;

  GetLeaderProfileDataUsecase({required LeaderDashboardRepository dashboardRepository}): _dashboardRepository = dashboardRepository;

  Future<Either<Failure, LeaderEntity>> call({required String leaderId}) async{
    return await _dashboardRepository.getLeaderProfileData(leaderId: leaderId);
  }
}
