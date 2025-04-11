part of 'registration_bloc.dart';

sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

final class RegistrationAAHandleChanged extends RegistrationEvent {
  const RegistrationAAHandleChanged(this.aaHandle);

  final String aaHandle;

  @override
  List<Object> get props => [aaHandle];
}

final class RegistrationMobileNumberChanged extends RegistrationEvent {
  const RegistrationMobileNumberChanged(this.mobileNumber);

  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}

final class RegistrationPasscodeChanged extends RegistrationEvent {
  const RegistrationPasscodeChanged(this.passcode);

  final String passcode;

  @override
  List<Object> get props => [passcode];
}

final class RegistrationConfirmPasscodeChanged extends RegistrationEvent {
  const RegistrationConfirmPasscodeChanged(this.passcode);

  final String passcode;

  @override
  List<Object> get props => [passcode];
}

final class RegistrationTermsAcceptanceChanged extends RegistrationEvent {
  const RegistrationTermsAcceptanceChanged(this.didAccept);

  final bool didAccept;

  @override
  List<Object> get props => [didAccept];
}

final class RegistrationRegisterClicked extends RegistrationEvent {
  const RegistrationRegisterClicked();
}

final class InitializeEvent extends RegistrationEvent {
  const InitializeEvent();
}
