part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileLoading extends ProfileEvent {}

final class LogoutInitiated extends ProfileEvent {}

final class CloseFinvuAccountInitiated extends ProfileEvent {
  final String password;

  CloseFinvuAccountInitiated(this.password);
}
