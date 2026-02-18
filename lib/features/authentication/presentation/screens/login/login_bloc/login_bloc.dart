import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faith_connect/core/common/entities/user_entity.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/login_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUsecase})
    : _loginUseCase = loginUsecase,
      super(LoginState()) {
    on<LoginEvent>((event, emit) {});

    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<TogglePasswordVisibility>(_onToggleVisibility);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onToggleVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValidLoginForm) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: "Email and Password are required!",
          failureTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      return;
    }
    emit(state.copyWith(status: LoginStatus.loading));
    final response = await _loginUseCase(email: state.email, password: state.password);
    response.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
          failureTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
      (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }
}
