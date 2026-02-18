import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/use_cases/profile_usecases/get_worshiper_stats.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/logout_usecase.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LogoutUseCase _logoutUseCase;
  final FetchWorshiperStatsUsecase _fetchWorshiperStatsUsecase;

  ProfileBloc({
    required LogoutUseCase logoutUsecase,
    required FetchWorshiperStatsUsecase worshipStatUsecase,
  })
      : _logoutUseCase = logoutUsecase,
        _fetchWorshiperStatsUsecase = worshipStatUsecase,
        super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {});
    on<FetchWorshiperStatus>(_fetchWorshiperStatus);
    on<LogoutEvent>(_logoutUser);
  }

  Future<void> _fetchWorshiperStatus(FetchWorshiperStatus event, Emitter<ProfileState> emit) async{
    final result = await _fetchWorshiperStatsUsecase();
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (success) => emit(ProfileSuccessState(worshiperStats: success)),
    );
  }

  Future<void> _logoutUser(LogoutEvent event, Emitter<ProfileState> emit) async {
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (success) {},
    );
  }
}
