part of 'on_boarding_bloc.dart';

sealed class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();

  @override
  List<Object?> get props => [];
}

final class FetchOnBoardingStatusEvent extends OnBoardingEvent {}

final class SetOnBoardingStatusEvent extends OnBoardingEvent {
  final String role;

  const SetOnBoardingStatusEvent({required this.role});

  @override
  List<Object?> get props => [role];
}

class OnPageChangedEvent extends OnBoardingEvent {
  final int pageIndex;

  const OnPageChangedEvent({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}
