part of 'recovery_bloc.dart';

sealed class RecoveryEvent extends Equatable {
  const RecoveryEvent();

  @override
  List<Object> get props => [];
}

final class InitializeEvent extends RecoveryEvent {}

final class RecoveryAAHandleChanged extends RecoveryEvent {
  const RecoveryAAHandleChanged(this.aaHandle);

  final String aaHandle;

  @override
  List<Object> get props => [aaHandle];
}

final class RecoveryNewPasscodeChanged extends RecoveryEvent {
  const RecoveryNewPasscodeChanged(this.passcode);

  final String passcode;

  @override
  List<Object> get props => [passcode];
}

final class RecoveryConfirmNewPasscodeChanged extends RecoveryEvent {
  const RecoveryConfirmNewPasscodeChanged(this.passcode);

  final String passcode;

  @override
  List<Object> get props => [passcode];
}

final class RecoveryMobileNumberChanged extends RecoveryEvent {
  const RecoveryMobileNumberChanged(this.mobileNumber);

  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}

final class RecoveryOTPChanged extends RecoveryEvent {
  const RecoveryOTPChanged(this.otp);

  final String otp;

  @override
  List<Object> get props => [otp];
}

final class RecoveryForgotAaHandleClicked extends RecoveryEvent {
  const RecoveryForgotAaHandleClicked();
}

final class RecoveryForgotPasscodeClicked extends RecoveryEvent {
  const RecoveryForgotPasscodeClicked();
}

final class RecoveryGetOtpClicked extends RecoveryEvent {
  final bool resend;
  const RecoveryGetOtpClicked(this.resend);
}

final class RecoveryOTPSubmitted extends RecoveryEvent {
  const RecoveryOTPSubmitted();
}

final class LoginWithRecoveredAaHandle extends RecoveryEvent {
  const LoginWithRecoveredAaHandle();
}
