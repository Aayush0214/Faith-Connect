import '../../../../../core/common/entities/message_entity.dart';
import '../../repositories/leader_chat_repository.dart';

class WatchLeaderMessagesUseCase {
  final LeaderChatRepository chatRepository;
  WatchLeaderMessagesUseCase({required this.chatRepository});

  Stream<List<MessageEntity>> call(String conversationId) => chatRepository.watchMessages(conversationId);
}