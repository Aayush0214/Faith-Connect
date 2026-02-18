import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserPhoto;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  const ChatEntity({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserPhoto,
    required this.lastMessage,
    required this.lastMessageAt,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [id, otherUserId, otherUserName, otherUserPhoto, unreadCount, lastMessage, lastMessageAt];
}