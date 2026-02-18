import 'package:faith_connect/features/worshipers/data/models/leader_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/core/common/models/post_model.dart';
import 'package:faith_connect/core/common/models/user_model.dart';
import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:faith_connect/features/leaders/data/datasources/dashboard_remote_datasource.dart';
import 'package:faith_connect/features/leaders/domain/repositories/dashboard_repository.dart';

class LeaderDashboardRepositoryImpl implements LeaderDashboardRepository {
  final LeaderDashboardRemoteDatasource _dashboardRemoteDatasource;

  LeaderDashboardRepositoryImpl({required LeaderDashboardRemoteDatasource dashboardDatasource}): _dashboardRemoteDatasource = dashboardDatasource;

  @override
  Future<Either<Failure, List<UserModel>>> getLeaderFollowersList({required String leaderId}) async{
    return await convertException(() async{
      return await _dashboardRemoteDatasource.getLeaderFollowersList(leaderId: leaderId);
    });
  }

  @override
  Future<Either<Failure, List<PostModel>>> getLeaderPosts({required String leaderId, required int from, required int to, String? postType}) async{
    return await convertException(() async{
      return await _dashboardRemoteDatasource.getLeaderPosts(leaderId: leaderId, from: from, to: to, postType: postType);
    });
  }

  @override
  Future<Either<Failure, LeaderModel>> getLeaderProfileData({required String leaderId}) async{
    return await convertException(() async{
      return await _dashboardRemoteDatasource.getLeaderProfileData(leaderId: leaderId);
    });
  }

  @override
  Future<Either<Failure, void>> deletePost({required String postId}) async{
    return await convertException(() async{
      return await _dashboardRemoteDatasource.deletePost(postId: postId);
    });
  }
}