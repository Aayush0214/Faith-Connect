import 'package:flutter/foundation.dart';
import '../model/signup_request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:faith_connect/core/common/models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  Future<AuthResponse> signup(SignupRequestModel model);
  Future<UserModel> login(String email, String password);
  Future<bool> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDatasourceImpl({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient;

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw const AuthException("Login failed: User null");
    }
    final userData = await _supabaseClient
        .from('users')
        .select()
        .eq('id', response.user!.id)
        .single();

    return UserModel.fromJson(userData);
  }

  @override
  Future<bool> logout() async {
    await _supabaseClient.auth.signOut();
    return true;
  }

  @override
  Future<AuthResponse> signup(SignupRequestModel model) async {
    String? imageUrl;
    String? uploadedPath;

    // 1. Agar image select ki hai, toh pehle upload karo
    if (model.profilePhoto != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      uploadedPath = 'userprofile/$fileName';

      try {
        // 1. Image Upload
        await _supabaseClient.storage.from('profiles').upload(uploadedPath, model.profilePhoto!);
        imageUrl = _supabaseClient.storage.from('profiles').getPublicUrl(uploadedPath);
      } catch (e) {
        throw const AuthException("Image upload fail ho gayi");
      }
    }

    // 2. Ab normal signup karo URL ke sath
    try{
      return await _supabaseClient.auth.signUp(
        email: model.email,
        password: model.password,
        data: {
          'full_name': model.fullName,
          'role': model.role,
          'faith': model.faith,
          'bio': model.bio,
          'profile_photo_url': imageUrl, // Ab yahan String URL jayega
        },
      );
    } catch (e) {
      if (uploadedPath != null) {
        await _supabaseClient.storage.from('profiles').remove([uploadedPath]);
        debugPrint("🧹 Auth fail hua, isliye image delete kar di gayi.");
      }
      rethrow;
    }
  }
}