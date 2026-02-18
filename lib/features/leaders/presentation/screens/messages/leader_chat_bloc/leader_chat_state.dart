part of 'leader_chat_bloc.dart';

sealed class LeaderChatState extends Equatable {
  const LeaderChatState();

  @override
  List<Object> get props => [];
}

final class LeaderChatInitial extends LeaderChatState {}

class LeaderChatLoading extends LeaderChatState {}

class InboxLoaded extends LeaderChatState {
  final List<ChatEntity> chats;
  const InboxLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

class MessagesLoaded extends LeaderChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class LeaderChatError extends LeaderChatState {
  final String message;
  const LeaderChatError({required this.message});

  @override
  List<Object> get props => [message];
}