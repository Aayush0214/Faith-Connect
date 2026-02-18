import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/leaders/domain/usecases/leader_chat_usecases/mark_leader_message_as_read.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/entities/chat_entity.dart';
import '../../../../../../core/common/entities/message_entity.dart';
import '../../../../domain/usecases/leader_chat_usecases/watch_leader_messages_usecase.dart';
import '../../../../domain/usecases/leader_chat_usecases/watch_leader_inbox_usecase.dart';
import '../../../../domain/usecases/leader_chat_usecases/send_leader_message_usecase.dart';

part 'leader_chat_event.dart';
part 'leader_chat_state.dart';

class LeaderChatBloc extends Bloc<LeaderChatEvent, LeaderChatState> {
  final WatchLeaderInboxUseCase _watchInbox;
  final WatchLeaderMessagesUseCase _watchMessages;
  final SendLeaderMessageUseCase _sendMessage;
  final MarkLeaderMessageAsReadUseCase _leaderMessageAsReadUseCase;

  StreamSubscription? _inboxSubscription;
  StreamSubscription? _messagesSubscription;

  LeaderChatBloc({
    required WatchLeaderInboxUseCase watchInbox,
    required WatchLeaderMessagesUseCase watchMessages,
    required SendLeaderMessageUseCase sendMessage,
    required MarkLeaderMessageAsReadUseCase leaderMessageAsReadUseCase,
  })  : _watchInbox = watchInbox,
        _watchMessages = watchMessages,
        _sendMessage = sendMessage,
        _leaderMessageAsReadUseCase = leaderMessageAsReadUseCase,
        super(LeaderChatInitial()) {

    // 1. Inbox Stream Logic
    on<WatchLeaderInboxEvent>((event, emit) {
      emit(LeaderChatLoading());
      _inboxSubscription?.cancel();
      _inboxSubscription = _watchInbox().listen(
        (chats) => add(_OnInboxUpdated(chats: chats)),
        onError: (e) => add(_OnChatError(message: e.toString())),
      );
    }, transformer: restartable());

    // 2. Messages Stream Logic
    on<WatchMessagesEvent>((event, emit) {
      emit(LeaderChatLoading());
      _messagesSubscription?.cancel();
      _messagesSubscription = _watchMessages(event.conversationId).listen(
        (messages) => add(_OnMessagesUpdated(messages: messages)),
        onError: (e) => add(_OnChatError(message: e.toString())),
      );
    }, transformer: restartable());

    // 3. UI Update Handlers
    on<_OnInboxUpdated>((event, emit) => emit(InboxLoaded(chats: event.chats)));
    on<_OnMessagesUpdated>((event, emit) => emit(MessagesLoaded(messages: event.messages)));

    // 4. Send Message Logic
    on<SendMessageEvent>((event, emit) async {
      final result = await _sendMessage(
        conversationId: event.conversationId,
        receiverId: event.receiverId,
        message: event.text,
      );

      result.fold(
        (failure) => emit(LeaderChatError(message: failure.message)),
        (_) => null,
      );
    }, transformer: sequential());

    on<MarkAsReadEvent>((event, emit) async {
      await _leaderMessageAsReadUseCase(event.conversationId);
    });

    on<_OnChatError>((event, emit) => emit(LeaderChatError(message: event.message)));

    on<CloseMessagesStreamEvent>((event, emit) {
      _messagesSubscription?.cancel(); // Stream band!
      _messagesSubscription = null;
      // State reset kar do taaki purani chat ke messages na dikhein
      emit(LeaderChatInitial());
    });
  }
}
