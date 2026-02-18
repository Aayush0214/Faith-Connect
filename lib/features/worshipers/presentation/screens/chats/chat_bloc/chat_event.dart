part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class FetchFollowedLeadersForChat extends ChatEvent {}

class InitiateChat extends ChatEvent {
  final String leaderId;
  final String leaderName;
  final String leaderPhoto;

  const InitiateChat({required this.leaderId, required this.leaderName, required this.leaderPhoto});

  @override
  List<Object?> get props => [leaderId, leaderName, leaderPhoto];
}

class ResetChatState extends ChatEvent {}

// chat_state.dart
class FollowedLeadersLoaded extends ChatState {
  final List<LeaderEntity> leaders;

  const FollowedLeadersLoaded(this.leaders);

  @override
  List<Object> get props => [leaders];
}

class ChatInitiationSuccess extends ChatState {
  final String conversationId;
  final String leaderId;
  final String leaderName;
  final String leaderPhoto;

  const ChatInitiationSuccess({
    required this.conversationId,
    required this.leaderId,
    required this.leaderName,
    required this.leaderPhoto
  });

  @override
  List<Object> get props => [conversationId, leaderId, leaderName, leaderPhoto];
}

class GetInboxEvent extends ChatEvent {}

class WatchMessagesEvent extends ChatEvent {
  final String conversationId;

  const WatchMessagesEvent({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

class WatchInboxEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String conversationId;
  final String receiverId;
  final String message;

  const SendMessageEvent({required this.conversationId, required this.receiverId, required this.message});

  @override
  List<Object?> get props => [conversationId, receiverId, message];
}

class MarkMessagesAsReadEvent extends ChatEvent {
  final String conversationId;

  const MarkMessagesAsReadEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}
