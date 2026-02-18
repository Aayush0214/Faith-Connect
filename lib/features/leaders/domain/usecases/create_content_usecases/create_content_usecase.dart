import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/leaders/data/models/upload_post_model.dart';
import 'package:faith_connect/features/leaders/domain/repositories/create_content_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateContentUsecase {
  final CreateContentRepository _createContentRepository;

  CreateContentUsecase({required CreateContentRepository createContentRepository}): _createContentRepository = createContentRepository;


  Future<Either<Failure, void>> call(UploadPostModel model) async{
    return await _createContentRepository.uploadPost(model);
  }

}