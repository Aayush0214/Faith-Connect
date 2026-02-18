import 'package:equatable/equatable.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leader_profile_event.dart';

part 'leader_profile_state.dart';

class LeaderProfileBloc extends Bloc<LeaderProfileEvent, LeaderProfileState> {
  final LogoutUseCase _logout;


  LeaderProfileBloc({required LogoutUseCase logoutUsecase})
    : _logout = logoutUsecase,
      super(LeaderProfileInitial()) {
    on<LeaderProfileEvent>((event, emit) {});
    on<LogoutEvent>(_logoutLeader);
  }

  Future<void> _logoutLeader(LogoutEvent event, Emitter<LeaderProfileState> emit) async {
    final result = await _logout();
    result.fold(
      (failure) => emit(LeaderProfileErrorState(errorMessage: failure.message)),
      (success) {},
    );
  }
}
