import '../../../../../core/common/entities/message_entity.dart';
import '../../repositories/chat_repository.dart';

class GetMessagesStreamUsecase {
  final ChatRepository _chatRepository;

  GetMessagesStreamUsecase({required ChatRepository chatRepository}): _chatRepository = chatRepository;

  Stream<List<MessageEntity>> call(String conversationId) {
    return _chatRepository.getMessagesStream(conversationId);
  }
}