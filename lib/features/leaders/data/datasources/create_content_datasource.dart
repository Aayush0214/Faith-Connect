import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:faith_connect/features/leaders/data/models/upload_post_model.dart';

abstract interface class CreateContentDatasource{
  Future<void> createPost(UploadPostModel uploadPostModel);
}

class CreateContentDatasourceImpl implements CreateContentDatasource{
  final SupabaseClient _supabase;

  CreateContentDatasourceImpl({required SupabaseClient supabase}): _supabase = supabase;

  @override
  Future<void> createPost(UploadPostModel uploadPostModel) async {
    final userId = _supabase.auth.currentUser!.id;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // 1. Upload Main Media (Compressed Video/Image)
    final mainExt = uploadPostModel.media.path.split('.').last;
    final mainPath = '$userId/${timestamp}_main.$mainExt';
    await _supabase.storage.from('posts').upload(mainPath, uploadPostModel.media);
    final mediaUrl = _supabase.storage.from('posts').getPublicUrl(mainPath);

    // 2. Upload Thumbnail (Sirf Reels ke liye)
    String? thumbnailUrl;
    if (uploadPostModel.thumbnail != null) {
      final thumbPath = '$userId/${timestamp}_thumb.jpg';
      await _supabase.storage.from('posts').upload(thumbPath, uploadPostModel.thumbnail!);
      thumbnailUrl = _supabase.storage.from('posts').getPublicUrl(thumbPath);
    } else {
      // Agar image post h toh mediaUrl hi thumbnail h
      thumbnailUrl = mediaUrl;
    }

    // 3. Database Entry
    await _supabase.from('posts').insert({
      'leader_id': userId,
      'post_type': uploadPostModel.postType,
      'caption': uploadPostModel.caption,
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'media_type': uploadPostModel.postType == 'reel' ? 'video' : 'image',
      'duration': uploadPostModel.duration,
      'likes_count': 0,
      'comments_count': 0,
    });
  }
}