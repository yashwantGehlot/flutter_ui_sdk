part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class HomeRefresh extends HomeEvent {
  const HomeRefresh();
}
