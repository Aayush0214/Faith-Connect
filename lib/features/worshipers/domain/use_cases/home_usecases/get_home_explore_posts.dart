import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/core/common/entities/post_entity.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetHomeExplorePostUsecase {
  final HomeRepository _homeRepository;

  GetHomeExplorePostUsecase({required HomeRepository homeRepository}) : _homeRepository = homeRepository;

  Future<Either<Failure, List<PostEntity>>> call({required int from, required int to}) async {
    return await _homeRepository.getExplorePosts(from: from, to: to);
  }
}