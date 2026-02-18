// UseCases
import 'package:faith_connect/features/leaders/domain/repositories/leader_chat_repository.dart';
import '../../../../../core/common/entities/chat_entity.dart';

class WatchLeaderInboxUseCase {
  final LeaderChatRepository chatRepository;
  WatchLeaderInboxUseCase({required this.chatRepository});

  Stream<List<ChatEntity>> call() => chatRepository.watchInbox();
}

