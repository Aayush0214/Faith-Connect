import 'package:faith_connect/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/chat_entity.dart';
import '../../../../core/common/entities/message_entity.dart';

abstract interface class ChatRepository{
  Future<Either<Failure, void>> sendMessage({required String conversationId, required String receiverId, required String message});
  Stream<List<MessageEntity>> getMessagesStream(String conversationId);
  Future<Either<Failure, List<ChatEntity>>> getInbox();
  Future<Either<Failure, String>> getOrCreateConversation(String leaderId);
  Future<Either<Failure, void>> markMessagesAsRead(String conversationId);

  Stream<List<ChatEntity>> watchInbox();
}