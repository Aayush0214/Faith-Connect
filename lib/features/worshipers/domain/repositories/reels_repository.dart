import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/core/common/entities/post_entity.dart';

abstract interface class ReelsRepository {
  Future<Either<Failure, List<PostEntity>>> getReels({required int from, required int to});
}