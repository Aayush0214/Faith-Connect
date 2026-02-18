import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/onboarding/presentation/bloc/on_boarding_bloc.dart';

class RouterNotifier extends ChangeNotifier {
  final SupabaseClient _supabase;
  final OnBoardingBloc _onboardingBloc; // Onboarding Bloc add kiya

  late final StreamSubscription<AuthState> _authSubscription;
  late final StreamSubscription<OnBoardingState> _onboardingSubscription;

  RouterNotifier({
    required SupabaseClient supabase,
    required OnBoardingBloc onboardingBloc,
  })  : _supabase = supabase,
        _onboardingBloc = onboardingBloc {

    // 1. Listen to Auth Changes (Login/Signup/Logout)
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      debugPrint('🔄 RouterNotifier - Auth Signal');
      debugPrint("🚨 ROUTER SIGNAL: ${data.event} | Session: ${data.session != null}");
      notifyListeners();
    });

    // 2. Listen to Onboarding Changes (Splash to Onboarding switch)
    _onboardingSubscription = _onboardingBloc.stream.listen((state) {
      debugPrint('🔄 RouterNotifier - Onboarding Signal');
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _onboardingSubscription.cancel();
    super.dispose();
  }
}

