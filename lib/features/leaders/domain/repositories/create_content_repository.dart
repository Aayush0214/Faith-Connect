import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/features/leaders/data/models/upload_post_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CreateContentRepository{
  Future<Either<Failure, void>> uploadPost(UploadPostModel post);
}