import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leader_model.dart';

abstract class LeaderRemoteDataSource {
  Future<List<LeaderModel>> getExploreLeaders({required int from, required int to, String? searchQuery});

  Future<List<LeaderModel>> getMyLeaders({required int from, required int to, String? searchQuery});

  Future<void> toggleFollowUnfollow(String leaderId);
}

class LeaderRemoteDataSourceImpl implements LeaderRemoteDataSource {
  final SupabaseClient _supabase;

  LeaderRemoteDataSourceImpl({required SupabaseClient supabase}): _supabase = supabase;

  // @override
  // Future<List<LeaderModel>> getExploreLeaders() async {
  //   final userId = _supabase.auth.currentUser!.id;
  //
  //   // Is query mein hum nested counts fetch kar rahe hain
  //   final response = await _supabase
  //       .from('users')
  //       .select('''
  //       *,
  //       followers:follows!leader_id(worshiper_id),
  //       posts!leader_id(count)
  //     ''')
  //       .eq('role', 'leader');
  //
  //   final List<dynamic> data = response as List;
  //
  //   return data.map((json) {
  //     // Current user is leader ko follow kar raha hai ya nahi?
  //     final followersList = json['followers'] as List? ?? [];
  //     final bool currentlyFollowing = followersList.any(
  //       (f) => f['worshiper_id'] == userId,
  //     );
  //
  //     return LeaderModel.fromJson(json, isFollowing: currentlyFollowing);
  //   }).toList();
  // }
  //
  // @override
  // Future<List<LeaderModel>> getMyLeaders() async {
  //   final userId = _supabase.auth.currentUser!.id;
  //
  //   // Pehle follows table se leader_ids nikalo, phir users table se detail counts ke sath
  //   final response = await _supabase
  //       .from('follows')
  //       .select('''
  //       users!leader_id (
  //         *,
  //         followers:follows!leader_id(count),
  //         posts!leader_id(count)
  //       )
  //     ''')
  //       .eq('worshiper_id', userId);
  //
  //   return (response as List).map((json) {
  //     // My leaders mein isFollowing hamesha true hoga
  //     return LeaderModel.fromJson(json['users'], isFollowing: true);
  //   }).toList();
  // }
///
  ///
  // Future<List<LeaderModel>> getExploreLeaders({required int from, required int to, String? searchQuery}) async {
  //   final userId = _supabase.auth.currentUser!.id;
  //
  //   // View use kar rahe hain, isliye count query likhne ki zarurat nahi
  //   var query = _supabase.from('leaders_with_counts').select('''
  //     *,
  //     is_followed:follows!leader_id(user_id)
  //   ''').eq('is_followed.user_id', userId);
  //   // Note: RLS handle kar lega ki sirf current user ka record check ho
  //
  //   if (searchQuery != null && searchQuery.isNotEmpty) {
  //     query = query.ilike('full_name', '%$searchQuery%');
  //   }
  //
  //   final response = await query
  //       .order('full_name', ascending: true)
  //       .range(from, to);
  //
  //   return (response as List).map((json) {
  //     // Check if current user follows this leader
  //     final isFollowing = (json['is_followed'] as List).isNotEmpty;
  //
  //     return LeaderModel.fromJson(json, isFollowing: isFollowing);
  //   }).toList();
  // }

  @override
  Future<List<LeaderModel>> getExploreLeaders({required int from, required int to, String? searchQuery}) async {
    final userId = _supabase.auth.currentUser!.id;

    var query = _supabase.from('leaders_with_counts').select('''
      *,
      is_followed:follows!leader_id(worshiper_id)
    ''').eq('is_followed.worshiper_id', userId); // Explicitly targeting worshiper_id

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('full_name', '%$searchQuery%');
    }

    final response = await query
        .order('full_name', ascending: true)
        .range(from, to);

    return (response as List).map((json) {
      // Agar is_followed list khali nahi hai, matlab follow karta h
      final isFollowing = (json['is_followed'] as List).isNotEmpty;
      return LeaderModel.fromJson(json, isFollowing: isFollowing);
    }).toList();
  }

  // @override
  // Future<List<LeaderModel>> getMyLeaders({required int from, required int to, String? searchQuery}) async {
  //   final userId = _supabase.auth.currentUser!.id;
  //
  //   // View ko follows table se connect karke details nikal rahe hain
  //   var query = _supabase.from('follows').select('''
  //     leader:leaders_with_counts (
  //       *
  //     )
  //   ''').eq('worshiper_id', userId);
  //
  //   if (searchQuery != null && searchQuery.isNotEmpty) {
  //     query = query.ilike('leader.full_name', '%$searchQuery%');
  //   }
  //
  //   final response = await query.range(from, to);
  //
  //   return (response as List).map((json) {
  //     // My leaders mein isFollowing hamesha true hoga
  //     return LeaderModel.fromJson(json['leader'], isFollowing: true);
  //   }).toList();
  // }
  @override
  Future<List<LeaderModel>> getMyLeaders({required int from, required int to, String? searchQuery}) async {
    final userId = _supabase.auth.currentUser!.id;

    // '!inner' ka jadu: Agar leader name match nahi karega toh wo follow record hi nahi aayega
    var query = _supabase.from('follows').select('''
    leader:leaders_with_counts!inner!leader_id (
      *
    )
  ''').eq('worshiper_id', userId);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Ab ye query ekdum accurate filter karegi
      query = query.ilike('leader.full_name', '%$searchQuery%');
    }

    // Range and Order
    final response = await query
        .order('leader(full_name)', ascending: true) // Nested sorting
        .range(from, to);

    final List<dynamic> data = response as List;

    return data.map((json) {
      // leader key hamesha present hogi because of !inner
      return LeaderModel.fromJson(json['leader'], isFollowing: true);
    }).toList();
  }

  @override
  Future<void> toggleFollowUnfollow(String leaderId) async {
    final userId = _supabase.auth.currentUser!.id;

    final existing = await _supabase
        .from('follows')
        .select('id')
        .eq('worshiper_id', userId)
        .eq('leader_id', leaderId)
        .maybeSingle();

    if (existing == null) {
      await _supabase.from('follows').insert({
        'worshiper_id': userId,
        'leader_id': leaderId,
      });
    } else {
      await _supabase
          .from('follows')
          .delete()
          .eq('worshiper_id', userId)
          .eq('leader_id', leaderId);
    }
  }
}
