import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/common/entities/chat_entity.dart';
import '../../repositories/chat_repository.dart';

class GetInboxUsecase {
  final ChatRepository _chatRepository;

  GetInboxUsecase({required ChatRepository chatRepository}): _chatRepository = chatRepository;

  Future<Either<Failure, List<ChatEntity>>> call() async {
   return await _chatRepository.getInbox();
  }
}