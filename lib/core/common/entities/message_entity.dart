import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String messageText;
  final bool isRead;
  final DateTime createdAt;
  final bool isMine; // UI logic ke liye help karega

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.messageText,
    required this.isRead,
    required this.createdAt,
    required this.isMine,
  });

  @override
  List<Object?> get props => [id, conversationId, senderId, messageText, isRead, createdAt, isMine];
}