import 'package:faith_connect/core/common/models/post_model.dart';
import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/worshipers/data/datasources/reels_remote_datasource.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/reels_repository.dart';

class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource _reelsRemoteDataSource;

  ReelsRepositoryImpl({required ReelsRemoteDataSource reelsRemoteDataSource}):_reelsRemoteDataSource = reelsRemoteDataSource;

  @override
  Future<Either<Failure, List<PostModel>>> getReels({required int from, required int to}) async{
    return await convertException(() async{
      return await _reelsRemoteDataSource.getReels(from: from, to: to);
    });
  }
}