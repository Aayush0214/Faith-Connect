import 'package:faith_connect/core/common/entities/comment_entity.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SocialActionRepository {
  Stream<Map<String, dynamic>> get socialUpdates;
  Future<Either<Failure, void>> handleLike(String postId);
  Future<Either<Failure, void>> handleSave(String postId);
  Future<Either<Failure, List<CommentEntity>>> getComments(String postId);
  Future<Either<Failure, void>> handleAddComment(String postId, String text);
  Future<Either<Failure, void>> handleDeleteComment(String commentId, String postId);
}