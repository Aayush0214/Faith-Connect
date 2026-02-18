import 'package:faith_connect/core/error/exception_handler.dart';
import 'package:faith_connect/core/error/failure.dart';
import 'package:faith_connect/core/common/models/chat_model.dart';
import 'package:faith_connect/core/common/models/message_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource chatRemoteDataSource}):_remoteDataSource = chatRemoteDataSource;

  @override
  Stream<List<MessageModel>> getMessagesStream(String conversationId) {
    return _remoteDataSource.getMessagesStream(conversationId);
  }

  @override
  Stream<List<ChatModel>> watchInbox() {
    return _remoteDataSource.watchInbox();
  }

  @override
  Future<Either<Failure, void>> sendMessage({required String conversationId, required String receiverId, required String message}) async {
    return await convertException(() async{
      return await _remoteDataSource.sendMessage(conversationId: conversationId, receiverId: receiverId, message: message);
    });
  }

  @override
  Future<Either<Failure, List<ChatModel>>> getInbox() async {
    return await convertException(() async{
      return await _remoteDataSource.getInbox();
    });
  }

  @override
  Future<Either<Failure, String>> getOrCreateConversation(String leaderId) async{
    return await convertException(() async{
      return await _remoteDataSource.getOrCreateConversation(leaderId);
    });
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(String conversationId) async {
    return await convertException(() async{
      return await _remoteDataSource.markMessagesAsRead(conversationId);
    });
  }
}