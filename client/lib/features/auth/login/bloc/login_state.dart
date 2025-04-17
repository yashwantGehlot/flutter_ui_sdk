part of 'login_bloc.dart';

enum LoginStatus {
  unknown,
  isAuthenticatingUsernamePasscode,
  isSendingOtp,
  isAuthenticatingOtp,
  loggedIn,
  needAuthentication,
  otpSent,
  mobileNumberVerified,
  invalidOtp,
  connectionEstablished,
  error
}

final class LoginState extends Equatable {
  final String aaHandle;
  final String passcode;
  final String mobileNumber;
  final String otp;
  final LoginStatus status;
  final int errorTimestamp;
  final FinvuError? error;

  const LoginState({
    this.aaHandle = "",
    this.passcode = "",
    this.mobileNumber = "",
    this.otp = "",
    this.error,
    this.status = LoginStatus.unknown,
    this.errorTimestamp = 0,
  });

  LoginState copyWith({
    String? aaHandle,
    String? passcode,
    String? mobileNumber,
    String? otp,
    required LoginStatus status,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == LoginStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    return LoginState(
      aaHandle: aaHandle ?? this.aaHandle,
      passcode: passcode ?? this.passcode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      otp: otp ?? this.otp,
      status: status,
      error: error,
      errorTimestamp: errorTimestamp,
    );
  }

  @override
  List<Object?> get props => [
        aaHandle,
        passcode,
        mobileNumber,
        otp,
        status,
        errorTimestamp,
        error,
      ];
}
