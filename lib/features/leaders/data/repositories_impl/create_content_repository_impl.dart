import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:faith_connect/features/leaders/data/models/upload_post_model.dart';
import 'package:faith_connect/features/leaders/data/datasources/create_content_datasource.dart';
import 'package:faith_connect/features/leaders/domain/repositories/create_content_repository.dart';

class CreateContentRepositoryImpl implements CreateContentRepository {
  final CreateContentDatasource _createContentDatasource;

  CreateContentRepositoryImpl({required CreateContentDatasource createContentDatasource}): _createContentDatasource = createContentDatasource;

  @override
  Future<Either<Failure, void>> uploadPost(UploadPostModel post) async{
    return await convertException(() async{
      return await _createContentDatasource.createPost(post);
    });
  }
}