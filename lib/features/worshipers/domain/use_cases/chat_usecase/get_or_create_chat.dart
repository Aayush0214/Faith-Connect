import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/chat_repository.dart';

class GetOrCreateChatUsecase {
  final ChatRepository _chatRepository;

  GetOrCreateChatUsecase({required ChatRepository chatRepository}): _chatRepository = chatRepository;

  Future<Either<Failure, String>> call(String leaderId) async {
    return await _chatRepository.getOrCreateConversation(leaderId);
  }
}