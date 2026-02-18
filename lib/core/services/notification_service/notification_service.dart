import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm;
  final SupabaseClient _supabase;

  NotificationService({
    required SupabaseClient supabase,
    required FirebaseMessaging firebaseMessaging,
  }): _fcm = firebaseMessaging,
      _supabase = supabase;

  Future<void> initNotifications() async {
    await _fcm.requestPermission();

    // 2. Token get karo
    String? token = await _fcm.getToken();

    if (token != null) {
      debugPrint("FCM Token: $token");
      await _saveTokenToDatabase(token);
    }

    // 3. Token refresh ho toh update karo
    _fcm.onTokenRefresh.listen(_saveTokenToDatabase);
  }

  Future<void> _saveTokenToDatabase(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      // Database mein token save/update karo
      await _supabase
          .from('users')
          .update({'fcm_token': token})
          .eq('id', userId);
    }
  }
}