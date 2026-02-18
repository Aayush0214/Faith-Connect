import 'package:faith_connect/core/common/entities/chat_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/common/models/message_model.dart';
import '../../../../core/error/failure.dart';

abstract interface class LeaderChatRepository{
  Stream<List<ChatEntity>> watchInbox();
  Stream<List<MessageModel>> watchMessages(String conversationId);
  Future<Either<Failure, void>> markMessagesAsRead(String conversationId);
  Future<Either<Failure, void>> sendMessage({required String conversationId, required String receiverId, required String message});
}