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
  final String mobileNumber;
  final String consentHandleId;
  final FinvuLoginOtpReference? otpReference;
  final String otp;

  final LoginStatus status;
  final int errorTimestamp;
  final FinvuError? error;

  const LoginState({
    this.aaHandle = "",
    this.mobileNumber = "",
    this.consentHandleId = "",
    this.otpReference,
    this.otp = "",
    this.error,
    this.status = LoginStatus.unknown,
    this.errorTimestamp = 0,
  });

  LoginState copyWith({
    required LoginStatus status,
    String? aaHandle,
    String? mobileNumber,
    String? consentHandleId,
    FinvuLoginOtpReference? otpReference,
    String? otp,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == LoginStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    return LoginState(
      aaHandle: aaHandle ?? this.aaHandle,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      consentHandleId: consentHandleId ?? this.consentHandleId,
      otpReference: otpReference ?? this.otpReference,
      otp: otp ?? this.otp,
      status: status,
      error: error,
      errorTimestamp: errorTimestamp,
    );
  }

  @override
  List<Object?> get props => [
        aaHandle,
        mobileNumber,
        consentHandleId,
        otpReference,
        otp,
        status,
        errorTimestamp,
        error,
      ];
}
