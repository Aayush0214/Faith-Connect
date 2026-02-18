import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/models/comment_model.dart';

abstract interface class SocialActionRemoteDataSource {
  Future<Map<String, dynamic>> toggleLike(String postId);
  Future<bool> toggleSave(String postId);
  Future<List<CommentModel>> getComments(String postId);
  Future<CommentModel> addComment(String postId, String text);
  Future<void> deleteComment(String commentId);
}

class SocialActionRemoteDataSourceImpl implements SocialActionRemoteDataSource {
  final SupabaseClient _supabase;
  SocialActionRemoteDataSourceImpl({required SupabaseClient supabaseClient}) : _supabase = supabaseClient;

  @override
  Future<Map<String, dynamic>> toggleLike(String postId) async {
    final response = await _supabase.rpc('toggle_post_like', params: {
      'p_post_id': postId,
      'p_user_id': _supabase.auth.currentUser!.id,
    });
    return response as Map<String, dynamic>;
  }

  @override
  Future<bool> toggleSave(String postId) async {
    final userId = _supabase.auth.currentUser!.id;
    final existing = await _supabase.from('saved_posts').select().eq('user_id', userId).eq('post_id', postId).maybeSingle();

    if (existing == null) {
      await _supabase.from('saved_posts').insert({'user_id': userId, 'post_id': postId});
      return true; // Saved
    } else {
      await _supabase.from('saved_posts').delete().eq('user_id', userId).eq('post_id', postId);
      return false; // Unsaved
    }
  }

  @override
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, users:user_id(full_name, profile_photo_url)')
          .eq('post_id', postId)
          .order('created_at', ascending: false);

      return (response as List).map((c) => CommentModel.fromJson(c)).toList();
    } catch (e) {
      throw Exception("Failed to fetch comments: $e");
    }
  }

  @override
  Future<CommentModel> addComment(String postId, String text) async {
    final response = await _supabase.from('comments').insert({
      'post_id': postId,
      'user_id': _supabase.auth.currentUser!.id,
      'comment_text': text,
    }).select('*, users:user_id(full_name, profile_photo_url)').single();
    return CommentModel.fromJson(response);
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _supabase.from('comments').delete().eq('id', commentId);
  }
}