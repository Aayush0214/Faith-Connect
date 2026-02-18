part of 'leader_chat_bloc.dart';

sealed class LeaderChatEvent extends Equatable {
  const LeaderChatEvent();

  @override
  List<Object?> get props => [];
}

class WatchLeaderInboxEvent extends LeaderChatEvent {
  @override
  List<Object?> get props => [];
}

class WatchMessagesEvent extends LeaderChatEvent {
  final String conversationId;
  const WatchMessagesEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class SendMessageEvent extends LeaderChatEvent {
  final String conversationId;
  final String receiverId;
  final String text;
  const SendMessageEvent({
    required this.conversationId,
    required this.receiverId,
    required this.text
  });

  @override
  List<Object?> get props => [conversationId, receiverId, text];
}

class _OnInboxUpdated extends LeaderChatEvent {
  final List<ChatEntity> chats;
  const _OnInboxUpdated({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class _OnMessagesUpdated extends LeaderChatEvent {
  final List<MessageEntity> messages;
  const _OnMessagesUpdated({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class MarkAsReadEvent extends LeaderChatEvent {
  final String conversationId;
  const MarkAsReadEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class _OnChatError extends LeaderChatEvent {
  final String message;
  const _OnChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CloseMessagesStreamEvent extends LeaderChatEvent {}