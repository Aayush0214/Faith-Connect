import 'package:faith_connect/core/common/models/chat_model.dart';
import 'package:faith_connect/core/common/models/message_model.dart';
import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:faith_connect/features/leaders/data/datasources/leader_chat_remote_datasource.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/leader_chat_repository.dart';

class LeaderChatRepositoryImpl implements LeaderChatRepository {
  final LeaderChatRemoteDataSource remoteDataSource;
  LeaderChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ChatModel>> watchInbox() {
    return remoteDataSource.watchLeaderInbox();
  }

  @override
  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return remoteDataSource.getMessages(conversationId);
  }

  @override
  Future<Either<Failure, void>> sendMessage({required String conversationId, required String receiverId, required String message}) async {
    return await convertException(() async{
      return await remoteDataSource.sendMessage(conversationId: conversationId, receiverId: receiverId, message: message);
    });
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(String conversationId) async {
    return await convertException(() async{
      return await remoteDataSource.markMessagesAsRead(conversationId);
    });
  }
}