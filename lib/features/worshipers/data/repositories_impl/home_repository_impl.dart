import '../../../../core/common/models/post_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../datasources/home_remote_datasource.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepositoryImpl({required HomeRemoteDataSource homeRemoteDataSource}) : _homeRemoteDataSource = homeRemoteDataSource;

  @override
  Future<Either<Failure, List<PostModel>>> getExplorePosts({required int from, required int to}) async {
    return await convertException(() async {
      return await _homeRemoteDataSource.getExplorePosts(from: from, to: to);
    });
  }

  @override
  Future<Either<Failure, List<PostModel>>> getFollowingPosts({required int from, required int to}) async {
    return await convertException(() async {
      return await _homeRemoteDataSource.getFollowingPosts(from: from, to: to);
    });
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPostsByLeaderId(leaderId) async{
    return await convertException(() async {
      return await _homeRemoteDataSource.getPostsByLeaderId(leaderId);
    });
  }
}