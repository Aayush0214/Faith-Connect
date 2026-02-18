import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/models/post_model.dart';

abstract interface class ReelsRemoteDataSource {
  Future<List<PostModel>> getReels({required int from, required int to});
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final SupabaseClient _supabase;

  ReelsRemoteDataSourceImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<List<PostModel>> getReels({required int from, required int to}) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    final response = await _supabase
        .from('posts_with_leader')
        .select('*, is_liked:likes(user_id), is_saved:saved_posts(user_id)')
        .filter('likes.user_id', 'eq', currentUserId)
        .eq('post_type', 'reel')
        .order('created_at', ascending: false)
        .range(from, to); // Pagination range

    return (response as List).map((post) => PostModel.fromJson(post)).toList();
  }
}