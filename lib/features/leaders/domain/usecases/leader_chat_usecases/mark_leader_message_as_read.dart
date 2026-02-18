import 'package:faith_connect/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/leader_chat_repository.dart';

class MarkLeaderMessageAsReadUseCase {
  final LeaderChatRepository chatRepository;
  MarkLeaderMessageAsReadUseCase({required this.chatRepository});

  Future<Either<Failure, void>> call(String conversationId) async {
    return await chatRepository.markMessagesAsRead(conversationId);
  }
}