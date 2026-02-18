import 'dart:async';
import 'package:faith_connect/core/common/entities/comment_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:faith_connect/features/social_action/domain/repository/social_repository.dart';
import 'package:faith_connect/features/social_action/data/remote_datasource/social_action_remote_datasource.dart';

class SocialActionRepositoryImpl implements SocialActionRepository {
  final SocialActionRemoteDataSource _socialActionRemoteDataSource;
  final _updateController = StreamController<Map<String, dynamic>>.broadcast();

  SocialActionRepositoryImpl({required SocialActionRemoteDataSource socialActionDatasource}):_socialActionRemoteDataSource = socialActionDatasource;

  @override
  Stream<Map<String, dynamic>> get socialUpdates => _updateController.stream;

  @override
  Future<Either<Failure, void>> handleLike(String postId) async{
    return await convertException(() async {
      final res = await _socialActionRemoteDataSource.toggleLike(postId);
      _updateController.add({
        'type': 'like_update',
        'postId': postId,
        'newCount': res['new_count'],
        'isLiked': res['is_liked']
      });
    });
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments(String postId) async{
    return await convertException(() async{
      return _socialActionRemoteDataSource.getComments(postId);
    });
  }

  @override
  Future<Either<Failure, void>> handleAddComment(String postId, String text) async{
    return await convertException(() async{
      final comment = await _socialActionRemoteDataSource.addComment(postId, text);
      _updateController.add({
        'type': 'comment_added',
        'postId': postId,
        'comment': comment
      });
    });
  }

  @override
  Future<Either<Failure, void>> handleDeleteComment(String commentId, String postId) async{
    return await convertException(() async{
      await _socialActionRemoteDataSource.deleteComment(commentId);
      _updateController.add({
        'type': 'comment_deleted',
        'postId': postId,
        'commentId': commentId
      });
    });
  }

  @override
  Future<Either<Failure, void>> handleSave(String postId) async{
    return await convertException(() async{
      final isSaved = await _socialActionRemoteDataSource.toggleSave(postId);
      _updateController.add({
        'type': 'save_update',
        'postId': postId,
        'isSaved': isSaved
      });
    });
  }
}