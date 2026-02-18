import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/models/chat_model.dart';
import '../../../../core/common/models/message_model.dart';

abstract interface class LeaderChatRemoteDataSource {
  Stream<List<ChatModel>> watchLeaderInbox();
  Stream<List<MessageModel>> getMessages(String conversationId);
  Future<void> markMessagesAsRead(String conversationId);
  Future<void> sendMessage({required String conversationId, required String receiverId, required String message});
}

class LeaderChatRemoteDataSourceImpl implements LeaderChatRemoteDataSource {
  final SupabaseClient supabase;
  LeaderChatRemoteDataSourceImpl({required this.supabase});

  @override
  Stream<List<ChatModel>> watchLeaderInbox() {
    final leaderId = supabase.auth.currentUser!.id;
    return supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .eq('leader_id', leaderId) // Leader ki apni chats
        .asyncMap((_) async {
      final response = await supabase
          .from('inbox_view')
          .select()
          .eq('leader_id', leaderId)
          .order('last_message_at', ascending: false);
      return response.map((json) => ChatModel.fromViewJson(json, leaderId)).toList();
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(String conversationId) {
    final currentUserId = supabase.auth.currentUser!.id;

    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .map((data) => data
        .map((json) => MessageModel.fromJson(json, currentUserId))
        .toList());
  }

  @override
  Future<void> sendMessage({required String conversationId, required String receiverId, required String message}) async {
    await supabase.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': supabase.auth.currentUser!.id,
      'receiver_id': receiverId,
      'message_text': message,
    }).select('created_at').single();

    // final String serverTime = data['created_at'];
    //
    // // 2. Conversations update karo server time ke saath
    // await supabase.from('conversations').update({
    //   'last_message': message,
    //   'last_message_at': serverTime,
    //   'updated_at': serverTime,
    // }).eq('id', conversationId);
  }

  @override
  Future<void> markMessagesAsRead(String conversationId) async {
    final userId = supabase.auth.currentUser!.id;

    // 1. Messages table update
    await supabase.from('messages').update({'is_read': true})
        .eq('conversation_id', conversationId).neq('sender_id', userId);

    // 2. Khud ka unread count 0 kar do
    // Pehle pata karo ki hum leader hain ya worshiper
    final response = await supabase.from('conversations').select().eq(
        'id', conversationId).single();

    String columnToUpdate = (response['worshiper_id'] == userId)
        ? 'worshiper_unread_count'
        : 'leader_unread_count';

    await supabase.from('conversations').update({
      columnToUpdate: 0,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', conversationId);
  }
}