part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

class InboxLoading extends ChatState {}

class InboxLoaded extends ChatState {
  final List<ChatEntity> chats;

  const InboxLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

class ChatLoading extends ChatState{}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;

  const MessagesLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}
