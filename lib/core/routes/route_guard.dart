import '../../injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:faith_connect/core/routes/route_names.dart';
import '../../features/onboarding/presentation/bloc/on_boarding_bloc.dart';

// class RouteGuards {
//   static Future<String?> globalRedirect(BuildContext context, GoRouterState state) async {
//     try {
//       final authState = context.read<AuthBloc>().state;
//       final onboardingState = context.read<OnBoardingBloc>().state;
//
//       final String loc = state.matchedLocation;
//
//       // 1. Loading handle karne ke liye
//       // --- 1. Loading States ---
//       if (onboardingState is OnBoardingInitial || authState is AuthInitial) {
//         return null;
//       }
//
//       // --- 2. Onboarding Logic ---
//       bool isOnboardingComplete = false;
//       String? role;
//
//       if (onboardingState is CurrentOnboardingState) {
//         isOnboardingComplete = onboardingState.isComplete;
//         role = onboardingState.role;
//
//         // --- FLOW 1: ONBOARDING CHECK ---
//         if (!isOnboardingComplete && loc != RouteNames.onboarding) {
//           return RouteNames.onboarding;
//         }
//
//         // --- FLOW 2: AUTH CHECK (Not Logged In) ---
//         if (isOnboardingComplete) {
//           // Agar Unauthenticated hai
//           if (authState is AuthUnauthenticated) {
//             // Edge Case: Role hi nahi hai (Data clear case)
//             if (role == null && loc != RouteNames.onboarding) return RouteNames.onboarding;
//
//             if (loc == RouteNames.login || loc == RouteNames.signup) return null;
//             return RouteNames.login;
//           }
//
//           // Agar Authenticated hai
//           if (authState is AuthAuthenticated) {
//             if (role == null) return RouteNames.onboarding; // Safety check
//
//             if (loc == RouteNames.login || loc == RouteNames.signup || loc == RouteNames.onboarding || loc == RouteNames.splash) {
//               return (role == 'leader') ? RouteNames.leaderDashBoard : RouteNames.worshiperHome;
//             }
//           }
//         }
//       }
//       return null;
//     } catch (e) {
//       debugPrint('🔥 RouteGuard Error: $e');
//       return RouteNames.splash;
//     }
//   }
// }

/// second guard

// class RouteGuards {
//   static Future<String?> globalRedirect(BuildContext context, GoRouterState state) async {
//     try {
//       final authState = context.read<AuthBloc>().state;
//       final onboardingState = context.read<OnBoardingBloc>().state;
//       final String loc = state.matchedLocation;
//
//       // 1. Loading States (Wait karo)
//       if (onboardingState is OnBoardingInitial || authState is AuthInitial) {
//         return null;
//       }
//
//       // --- FLOW A: NOT LOGGED IN (Rely on Onboarding State) ---
//       // --- FLOW A: NOT LOGGED IN (Rely on Onboarding State) ---
//       if (authState is AuthUnauthenticated) {
//
//         if (onboardingState is CurrentOnboardingState) {
//           // CASE 1: Onboarding Complete Nahi Hai
//           if (!onboardingState.isComplete) {
//             if (loc == RouteNames.onboarding) {
//               return null;
//             }
//             return RouteNames.onboarding;
//           }
//         }
//
//         // CASE 2: Onboarding Complete Hai (Ab Login/Signup allow karo)
//         if (loc == RouteNames.login || loc == RouteNames.signup) {
//           return null; // Login/Signup par rehne do
//         }
//
//         // Agar onboarding complete hai par user kahin aur bhatak raha hai -> Login par bhejo
//         return RouteNames.login;
//       }
//
//       // --- FLOW B: LOGGED IN (Rely on Supabase Metadata) ---
//       if (authState is AuthAuthenticated) {
//         // YAHAN FIX HAI: Local state bhool jao, User object se role nikalo
//         final user = authState.user;
//
//         // Metadata se role fetch karo
//         // Note: key wahi honi chahiye jo signup me bheji thi ('role')
//         final String? dbRole = user.userMetadata?['role'];
//
//         // Agar DB me role nahi hai (Rare case: Data corruption/Manual entry)
//         if (dbRole == null) {
//           // Fallback: Wapas onboarding ya error page bhej sakte ho
//           // Filhaal onboarding safe hai taaki wo fir se signup flow try kare
//           return RouteNames.onboarding;
//         }
//
//         // Agar user Login/Signup page par hai, toh Dashboard bhejo
//         if (loc == RouteNames.login || loc == RouteNames.signup || loc == RouteNames.onboarding || loc == RouteNames.splash) {
//           if (dbRole == 'leader') {
//             return RouteNames.leaderDashBoard;
//           } else {
//             return RouteNames.worshiperHome;
//           }
//         }
//       }
//
//       return null;
//     } catch (e) {
//       debugPrint('🔥 RouteGuard Error: $e');
//       return RouteNames.splash;
//     }
//   }
// }

/// third

class RouteGuards {
  static Future<String?> globalRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    try {
      // AuthBloc ki jagah seedha Supabase se pucho "Current user hai kya?"
      final supabase = sl<SupabaseClient>();
      final user = supabase.auth.currentUser;
      final onboardingState = context.read<OnBoardingBloc>().state;
      final String loc = state.matchedLocation;

      // --- 1. Loading States ---
      // Agar onboarding state initial hai, tabhi ruko
      if (onboardingState is OnBoardingInitial) return null;

      // --- FLOW A: NOT LOGGED IN ---
      if (user == null) {
        if (onboardingState is CurrentOnboardingState) {
          if (!onboardingState.isComplete) {
            return (loc == RouteNames.onboarding)
                ? null
                : RouteNames.onboarding;
          }
        }
        if (loc == RouteNames.login || loc == RouteNames.signup) return null;
        return RouteNames.login;
      }

      // --- FLOW B: LOGGED IN (user != null) ---
      // Metadata se role fetch karo
      final String? dbRole = user.userMetadata?['role'];

      if (dbRole == null) return RouteNames.onboarding;

      // Redirection logic
      if (loc == RouteNames.login ||
          loc == RouteNames.signup ||
          loc == RouteNames.onboarding ||
          loc == RouteNames.splash) {
        return (dbRole == 'leader')
            ? RouteNames.leaderDashboard
            : RouteNames.worshiperHome;
      }

      return null;
    } catch (e) {
      debugPrint('🔥 RouteGuard Error: $e');
      return RouteNames.splash;
    }
  }
}
