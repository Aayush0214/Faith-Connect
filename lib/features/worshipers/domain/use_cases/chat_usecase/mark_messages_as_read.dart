import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/chat_repository.dart';

class MarkMessagesAsReadUsecase {
  final ChatRepository _chatRepository;

  MarkMessagesAsReadUsecase({required ChatRepository chatRepository}): _chatRepository = chatRepository;

  Future<Either<Failure, void>> call(String conversationId) async {
    return await _chatRepository.markMessagesAsRead(conversationId);
  }
}