import '../../../../core/common/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<PostModel>> getExplorePosts({required int from, required int to});
  Future<List<PostModel>> getFollowingPosts({required int from, required int to});
  Future<List<PostModel>> getPostsByLeaderId(String leaderId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient _supabase;

  HomeRemoteDataSourceImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<List<PostModel>> getExplorePosts({required int from, required int to}) async {
    final response = await _supabase.rpc('get_posts_with_engagement', params: {
      'user_uuid': _supabase.auth.currentUser!.id,
      'from_index': from,
      'to_index': to,
    });
    return (response as List).map((post) => PostModel.fromJson(post)).toList();
  }

  @override
  Future<List<PostModel>> getFollowingPosts({required int from, required int to}) async {
    final userId = _supabase.auth.currentUser!.id;

    // Step 1: Following list nikalo
    final followingData = await _supabase
        .from('follows')
        .select('leader_id')
        .eq('worshiper_id', userId);

    final List<dynamic> followingList = followingData as List;
    if (followingList.isEmpty) return [];

    final List<String> leaderIds = followingList
        .map((e) => e['leader_id'].toString())
        .toList();

    // Step 2: Posts nikalo with pagination
    final response = await _supabase
        .from('posts_with_leader')
        .select('*, is_liked:likes(user_id), is_saved:saved_posts(user_id)')
        .inFilter('leader_id', leaderIds)
        .order('created_at', ascending: false)
        .range(from, to);

    return (response as List).map((post) => PostModel.fromJson(post)).toList();
  }

  @override
  Future<List<PostModel>> getPostsByLeaderId(String leaderId) async {
    final response = await _supabase
        .from('posts_with_leader')
        .select()
        .eq('leader_id', leaderId)
        .order('created_at', ascending: false);

    return (response as List).map((p) => PostModel.fromJson(p)).toList();
  }
}