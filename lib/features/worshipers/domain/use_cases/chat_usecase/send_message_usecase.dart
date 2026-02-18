import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository _chatRepository;
  SendMessageUsecase({required ChatRepository chatRepository}): _chatRepository = chatRepository;

  Future<Either<Failure, void>> call({required String conversationId, required String receiverId, required String message}) async {
    return await _chatRepository.sendMessage(conversationId: conversationId, receiverId: receiverId, message: message);
  }
}