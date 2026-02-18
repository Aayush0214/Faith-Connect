import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/common/models/chat_model.dart';
import '../../../../core/common/models/message_model.dart';

abstract interface class ChatRemoteDataSource {
  Future<void> sendMessage({required String conversationId, required String receiverId, required String message});
  Stream<List<MessageModel>> getMessagesStream(String conversationId);
  Future<List<ChatModel>> getInbox();
  Future<String> getOrCreateConversation(String leaderId);
  Future<void> markMessagesAsRead(String conversationId);

  Stream<List<ChatModel>> watchInbox();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource{
  final SupabaseClient _supabase;

  ChatRemoteDataSourceImpl({required SupabaseClient supabase}):_supabase = supabase;

  @override
  Future<void> sendMessage({required String conversationId, required String receiverId, required String message}) async {
    final myId = _supabase.auth.currentUser!.id;
    await _supabase.from('messages').insert({
      'sender_id': myId,
      'receiver_id': receiverId,
      'message_text': message,
      'conversation_id': conversationId,
    });
    // final String serverTime = data['created_at'];
    // await _supabase.from('conversations').update({
    //   'last_message': message,
    //   'last_message_at': serverTime,
    //   'updated_at': serverTime,
    // }).eq('id', conversationId);
  }

  @override
  Stream<List<MessageModel>> getMessagesStream(String conversationId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at',) // Newest messages at bottom (with ListView reverse: true)
        .map((data) => data.map((json) => MessageModel.fromJson(json, _supabase.auth.currentUser!.id)).toList());
  }

  @override
  Future<List<ChatModel>> getInbox() async {
    final userId = _supabase.auth.currentUser!.id;

    final response = await _supabase
        .from('conversations')
        .select('''
        *,
        leader:leader_id(full_name, profile_photo_url),
        worshiper:worshiper_id(full_name, profile_photo_url),
        unread_count:messages(count)
      ''')
        .or('worshiper_id.eq.$userId,leader_id.eq.$userId')
        .eq('messages.is_read', false) // Sirf unread messages
        .neq('messages.sender_id', userId) // Jo maine nahi bheje
        .order('updated_at', ascending: false);

    return (response as List)
        .map((json) => ChatModel.fromJson(json, userId))
        .toList();
  }

  @override
  Stream<List<ChatModel>> watchInbox() {
    final userId = _supabase.auth.currentUser!.id;

    return _supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .map((event) =>
        event.where((json) =>
        json['worshiper_id'] == userId || json['leader_id'] == userId).toList())
        .asyncMap((_) async {
      final response = await _supabase
          .from('inbox_view')
          .select()
          .or('worshiper_id.eq.$userId,leader_id.eq.$userId') // Dono check karo
          .order('updated_at', ascending: false);

      return response
          .map((json) => ChatModel.fromViewJson(json, userId))
          .toList();
    });
  }

  @override
  Future<String> getOrCreateConversation(String leaderId) async {
    final worshiperId = _supabase.auth.currentUser!.id;
    final response = await _supabase
        .from('conversations')
        .select('id')
        .eq('worshiper_id', worshiperId)
        .eq('leader_id', leaderId)
        .maybeSingle();

    if (response != null) return response['id'];

    // Create new
    final newConv = await _supabase.from('conversations').insert({
      'worshiper_id': worshiperId,
      'leader_id': leaderId,
    }).select().single();

    return newConv['id'];
  }

  @override
  Future<void> markMessagesAsRead(String conversationId) async {
    final userId = _supabase.auth.currentUser!.id;

    // 1. Messages table update
    await _supabase.from('messages').update({'is_read': true})
        .eq('conversation_id', conversationId).neq('sender_id', userId);

    // 2. Khud ka unread count 0 kar do
    // Pehle pata karo ki hum leader hain ya worshiper
    final response = await _supabase.from('conversations').select().eq(
        'id', conversationId).single();

    String columnToUpdate = (response['worshiper_id'] == userId)
        ? 'worshiper_unread_count'
        : 'leader_unread_count';

    await _supabase.from('conversations').update({
      columnToUpdate: 0,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', conversationId);
  }
}