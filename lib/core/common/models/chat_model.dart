import '../entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.unreadCount,
    required super.otherUserId,
    required super.otherUserName,
    required super.otherUserPhoto,
    required super.lastMessage,
    required super.lastMessageAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    bool isWorshiper = json['worshiper_id'] == currentUserId;
    var otherUser = isWorshiper
        ? json['leader']
        : json['worshiper'];

    int count = 0;
    if (json['unread_count'] != null && (json['unread_count'] as List).isNotEmpty) {
      count = json['unread_count'][0]['count'] ?? 0;
    }

    return ChatModel(
      id: json['id'],
      otherUserId: isWorshiper ? json['leader_id'] : json['worshiper_id'],
      otherUserName: otherUser['full_name'] ?? 'Unknown',
      otherUserPhoto: otherUser['profile_photo_url'],
      lastMessage: json['last_message'] ?? '',
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at']).toLocal()
          : DateTime.now(),
      unreadCount: count,
    );
  }

  factory ChatModel.fromViewJson(Map<String, dynamic> json, String currentUserId) {
    bool isWorshiper = json['worshiper_id'] == currentUserId;

    return ChatModel(
      id: json['conversation_id'],
      otherUserId: isWorshiper ? json['leader_id'] : json['worshiper_id'],
      otherUserName: isWorshiper
          ? (json['leader_name'] ?? 'Unknown')
          : (json['worshiper_name'] ?? 'Unknown'),
      otherUserPhoto: isWorshiper
          ? json['leader_photo']
          : json['worshiper_photo'],
      lastMessage: json['last_message'] ?? '',
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at']).toLocal()
          : DateTime.now(),
      unreadCount: json['unread_count'] ?? 0,
    );
  }

}
