import '../../../../../core/common/entities/chat_entity.dart';
import '../../repositories/chat_repository.dart';

class WatchInboxUsecase {
  final ChatRepository _chatRepository;

  WatchInboxUsecase({required ChatRepository chatRepository}): _chatRepository = chatRepository;

  Stream<List<ChatEntity>> call() {
    return _chatRepository.watchInbox();
  }
}