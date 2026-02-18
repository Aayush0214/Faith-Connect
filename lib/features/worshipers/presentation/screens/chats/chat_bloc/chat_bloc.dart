import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/chat_usecase/get_message_stream.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/chat_usecase/mark_messages_as_read.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/chat_usecase/watch_chat_inbox.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/common/entities/chat_entity.dart';
import '../../../../domain/entities/leader_entity.dart';
import '../../../../../../core/common/entities/message_entity.dart';
import '../../../../domain/use_cases/chat_usecase/get_inbox_usecase.dart';
import '../../../../domain/use_cases/chat_usecase/get_or_create_chat.dart';
import '../../../../domain/use_cases/chat_usecase/send_message_usecase.dart';
import '../../../../domain/use_cases/leader_usecases/fetch_followed_leaders.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetInboxUsecase _getInbox;
  final GetMessagesStreamUsecase _getMessagesStream;
  final WatchInboxUsecase _watchInboxUsecase;
  final SendMessageUsecase _sendMessage;
  final GetOrCreateChatUsecase _getOrCreateChat;
  final FetchFollowedLeadersUsecase _fetchFollowedLeaders;
  final MarkMessagesAsReadUsecase _markMessagesAsReadUsecase;

  ChatBloc({
    required GetInboxUsecase getInbox,
    required GetMessagesStreamUsecase getMessagesStream,
    required SendMessageUsecase sendMessage,
    required WatchInboxUsecase watchInboxUsecase,
    required GetOrCreateChatUsecase getOrCreateChat,
    required MarkMessagesAsReadUsecase markedAsReadUsecase,
    required FetchFollowedLeadersUsecase fetchFollowedLeaders,
  }) : _getInbox = getInbox,
        _getMessagesStream = getMessagesStream,
        _sendMessage = sendMessage,
        _watchInboxUsecase = watchInboxUsecase,
        _getOrCreateChat = getOrCreateChat,
        _fetchFollowedLeaders = fetchFollowedLeaders,
        _markMessagesAsReadUsecase = markedAsReadUsecase,

        super(ChatInitial()) {

    on<InitiateChat>((event, emit) async {
      final res = await _getOrCreateChat(event.leaderId);
      res.fold(
         (failure) => emit(ChatError(message: failure.message)),
         (convId) {
           emit(ChatInitiationSuccess(
             conversationId: convId,
             leaderId: event.leaderId,
             leaderName: event.leaderName,
             leaderPhoto: event.leaderPhoto,
           ));
         },
      );
    });


    on<GetInboxEvent>((event, emit) async {
      emit(InboxLoading());
      final res = await _getInbox();
      res.fold(
        (failure) => emit(ChatError(message: failure.message)),
        (chats) => emit(InboxLoaded(chats: chats)),
      );
    });

    on<WatchMessagesEvent>((event, emit) async {
      await emit.forEach<List<MessageEntity>>(
        _getMessagesStream(event.conversationId),
        onData: (messages) => MessagesLoaded(messages: messages),
        onError: (error, _) => ChatError(message: error.toString()),
      );
    }, transformer: restartable());

    on<WatchInboxEvent>((event, emit) async {
      emit(InboxLoading());
      await emit.forEach<List<ChatEntity>>(
        _watchInboxUsecase(),
        onData: (chats) => InboxLoaded(chats: chats),
        onError: (error, stackTrace) => ChatError(message: error.toString()),
      );
    }, transformer: restartable());

    // ChatBloc ke andar SendMessageEvent ko aise update karo:
    on<SendMessageEvent>((event, emit) async {
      await _sendMessage(
          conversationId: event.conversationId,
          receiverId: event.receiverId,
          message: event.message
      );
    }, transformer: sequential());

    on<FetchFollowedLeadersForChat>((event, emit) async {
      final res = await _fetchFollowedLeaders(from: 0, to: 10, searchQuery: null);
      res.fold(
        (failure) => emit(ChatError(message: failure.message)),
        (leaders) => emit(FollowedLeadersLoaded(leaders)),
      );
    });

    on<MarkMessagesAsReadEvent>((event, emit) async {
      await _markMessagesAsReadUsecase(event.conversationId);
    });

    on<ResetChatState>((event, emit) {
      // Kyunki ye restartable hai, naya handler (ResetChatState) fire hote hi
      // pichla WatchMessagesEvent wala stream automatic band ho jayega!
      emit(ChatInitial());
    }, transformer: restartable());
  }
}
