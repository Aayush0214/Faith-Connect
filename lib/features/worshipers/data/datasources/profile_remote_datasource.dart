import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Future<Map<String, int>> getWorshiperStats();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _supabase;

  ProfileRemoteDataSourceImpl({required SupabaseClient supabase}): _supabase = supabase;

  // Profile Repository Implementation
  @override
  Future<Map<String, int>> getWorshiperStats() async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      // 1. Following Count
      // Supabase ka naya return type 'PostgrestResponse' use karna padta h count ke liye
      final following = await _supabase
          .from('follows')
          .select('id') // 'id' select karo
          .eq('worshiper_id', userId)
          .count(CountOption.exact); // Method chaining syntax

      // 2. Saved Posts Count
      final saved = await _supabase
          .from('saved_posts')
          .select('id')
          .eq('user_id', userId)
          .count(CountOption.exact);

      // 3. Likes Count
      final likes = await _supabase
          .from('likes')
          .select('id')
          .eq('user_id', userId)
          .count(CountOption.exact);

      // 4. Comments Count
      final comments = await _supabase
          .from('comments')
          .select('id')
          .eq('user_id', userId)
          .count(CountOption.exact);

      return {
        'following': following.count,
        'saved': saved.count,
        'interactions': (likes.count + comments.count),
      };
    } catch (e) {
      // Agar koi error aaye (jaise network issue)
      debugPrint("Error fetching stats: $e");
      return {
        'following': 0,
        'saved': 0,
        'interactions': 0,
      };
    }
  }
}