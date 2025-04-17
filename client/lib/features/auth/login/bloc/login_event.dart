part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class InitializeEvent extends LoginEvent {}

final class LoginAAHandleChanged extends LoginEvent {
  const LoginAAHandleChanged(this.aaHandle);

  final String aaHandle;

  @override
  List<Object> get props => [aaHandle];
}

final class LoginPasscodeChanged extends LoginEvent {
  const LoginPasscodeChanged(this.passcode);

  final String passcode;

  @override
  List<Object> get props => [passcode];
}

final class LoginAAHandlePasscodeSubmitted extends LoginEvent {
  const LoginAAHandlePasscodeSubmitted();
}

final class LoginMobileNumberChanged extends LoginEvent {
  const LoginMobileNumberChanged(this.mobileNumber);

  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}

final class LoginOTPChanged extends LoginEvent {
  const LoginOTPChanged(this.otp);

  final String otp;

  @override
  List<Object> get props => [otp];
}

final class LoginMobileNumberSubmitted extends LoginEvent {
  const LoginMobileNumberSubmitted();
}

final class LoginOTPSubmitted extends LoginEvent {
  const LoginOTPSubmitted();
}

final class LoginMobileVerificationInitiated extends LoginEvent {
  const LoginMobileVerificationInitiated(this.mobileNumber);
  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}

final class LoginMobileVerificationComplete extends LoginEvent {
  const LoginMobileVerificationComplete(this.mobileNumber, this.otp);
  final String mobileNumber;
  final String otp;

  @override
  List<Object> get props => [mobileNumber, otp];
}
