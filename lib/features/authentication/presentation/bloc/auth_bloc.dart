import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AppAuthState> {
  final SupabaseClient _supabase;
  final LogoutUseCase _logoutUseCase;
  StreamSubscription<AuthState>? _supabaseSubscription;

  AuthBloc({
    required LogoutUseCase logoutUsecase,
    required SupabaseClient supabaseInstance,
  })
    : _supabase = supabaseInstance,
      _logoutUseCase = logoutUsecase,
      super(AuthInitial()) {

    on<AuthCheckSession>(_checkAuthSession);
    on<AuthStatusChanged>(_authStatusChanged);
    on<AuthLogoutRequested>(_authLogout);
  }

  void _checkAuthSession(AuthCheckSession event, Emitter<AppAuthState> emit) async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      emit(AuthAuthenticated(session.user));
    } else {
      emit(AuthUnauthenticated());
    }

    // 2. AB Stream ko listen karna shuru karo (Sirf ek baar)
    _supabaseSubscription?.cancel(); // Purana koi ho toh band karo
    _supabaseSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      add(AuthStatusChanged(data.session?.user));
    });
  }

  void _authStatusChanged(AuthStatusChanged event, Emitter<AppAuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _authLogout(AuthLogoutRequested event, Emitter<AppAuthState> emit) async {
    await _logoutUseCase();
  }

  @override
  Future<void> close() {
    _supabaseSubscription?.cancel();
    return super.close();
  }
}
