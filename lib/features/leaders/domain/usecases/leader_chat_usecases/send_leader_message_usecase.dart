import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/leader_chat_repository.dart';

class SendLeaderMessageUseCase {
  final LeaderChatRepository chatRepository;
  SendLeaderMessageUseCase({required this.chatRepository});

  Future<Either<Failure, void>> call({
    required String conversationId,
    required String receiverId,
    required String message,
  }) {
    return chatRepository.sendMessage(
      conversationId: conversationId,
      receiverId: receiverId,
      message: message,
    );
  }
}