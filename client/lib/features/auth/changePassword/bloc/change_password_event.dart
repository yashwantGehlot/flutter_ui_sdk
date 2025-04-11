part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

final class ChangePasswordSubmit extends ChangePasswordEvent {
  const ChangePasswordSubmit(this.currentPasscode, this.newPasscode);
  final String currentPasscode;
  final String newPasscode;

  @override
  List<Object> get props => [currentPasscode, newPasscode];
}
