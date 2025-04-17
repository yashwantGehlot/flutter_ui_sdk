part of 'splash_bloc.dart';

sealed class SplashEvent {
  const SplashEvent();
}

final class SplashLoading extends SplashEvent {}
