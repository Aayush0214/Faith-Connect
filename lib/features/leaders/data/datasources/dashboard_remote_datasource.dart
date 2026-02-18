import 'package:faith_connect/core/common/models/post_model.dart';
import 'package:faith_connect/core/common/models/user_model.dart';
import 'package:faith_connect/features/worshipers/data/models/leader_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class LeaderDashboardRemoteDatasource{
  Future<LeaderModel> getLeaderProfileData({required String leaderId});
  Future<List<UserModel>> getLeaderFollowersList({required String leaderId});
  Future<List<PostModel>> getLeaderPosts({required String leaderId, required int from, required int to, String? postType});
  Future<void> deletePost({required String postId});
}

class LeaderDashboardRemoteDatasourceImpl implements LeaderDashboardRemoteDatasource {
  final SupabaseClient _supabase;

  LeaderDashboardRemoteDatasourceImpl({required SupabaseClient supabase}): _supabase = supabase;

  @override
  Future<LeaderModel> getLeaderProfileData({required String leaderId}) async {
    final currentUserId = _supabase.auth.currentUser!.id;

    final response = await _supabase
        .from('leaders_with_counts') // Hamara optimized View
        .select('''
        *,
        is_followed:follows!leader_id(worshiper_id)
      ''')
        .eq('id', leaderId)
        .eq('is_followed.worshiper_id', currentUserId)
        .maybeSingle();

    if (response == null) throw Exception("Leader not found");

    // Check if current user follows this leader
    final isFollowing = (response['is_followed'] as List).isNotEmpty;

    return LeaderModel.fromJson(response, isFollowing: isFollowing);
  }

  @override
  Future<List<UserModel>> getLeaderFollowersList({required String leaderId}) async {
    final response = await _supabase
        .from('follows')
        .select('worshiper:users!worshiper_id(*)')
        .eq('leader_id', leaderId);

    if ((response as List).isEmpty) return [];

    return (response as List).map((data) {
      final userData = data['worshiper'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    }).toList();
  }

  @override
  Future<List<PostModel>> getLeaderPosts({required String leaderId, required int from, required int to, String? postType}) async {
    // Current logged-in user ki ID lo (chahe leader ho ya worshipper)
    final currentUserId = _supabase.auth.currentUser!.id;

    var query = _supabase
        .from('posts')
        .select('''
        *,
        leader:users!leader_id(*),
        is_liked:likes!left(user_id),
        is_saved:saved_posts!left(user_id)
      ''')
        .eq('leader_id', leaderId)
    // YE HAI MAGIC: Sirf wahi like/save lao jo current user ne kiya hai
        .eq('likes.user_id', currentUserId)
        .eq('saved_posts.user_id', currentUserId);

    if (postType != null) {
      query = query.eq('post_type', postType);
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(from, to);

    return (response as List).map((post) {
      final postData = Map<String, dynamic>.from(post);

      // Logic: Agar is_liked list empty nahi hai, matlab current user ne like kiya hai
      postData['isLiked'] = (post['is_liked'] as List).isNotEmpty;
      postData['isSaved'] = (post['is_saved'] as List).isNotEmpty;

      return PostModel.fromJson(postData);
    }).toList();
  }

  @override
  Future<void> deletePost({required String postId}) async {
    await _supabase
        .from('posts')
        .delete()
        .eq('id', postId);
  }
}