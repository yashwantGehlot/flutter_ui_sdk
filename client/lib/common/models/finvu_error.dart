import 'package:finvu_flutter_sdk_core/finvu_exception.dart';

class FinvuError {
  final FinvuErrorCode code;
  final String? message;

  FinvuError(
    this.code,
    this.message,
  );
}

enum FinvuErrorCode {
  authLoginRetry,
  authLoginFailed,
  authForgotPasscodeFailed,
  authForgotHandleFailed,
  authLoginVerifyMobileNumber,
  sessionDisconnected,
  logout,
  sslPinningFailureError,
  genericError;
}

extension FinvuErrorExtension on FinvuException {
  FinvuError toFinvuError() {
    switch (code) {
      case 1001:
        return FinvuError(FinvuErrorCode.authLoginRetry, message);
      case 1002:
        return FinvuError(FinvuErrorCode.authLoginFailed, message);
      case 1003:
        return FinvuError(FinvuErrorCode.authForgotPasscodeFailed, message);
      case 1004:
        return FinvuError(FinvuErrorCode.authLoginVerifyMobileNumber, message);
      case 1005:
        return FinvuError(FinvuErrorCode.authForgotHandleFailed, message);
      case 8000:
        return FinvuError(FinvuErrorCode.sessionDisconnected, message);
      case 8001:
        return FinvuError(FinvuErrorCode.sslPinningFailureError, message);
      case 9000:
        return FinvuError(FinvuErrorCode.logout, message);
      default:
        return FinvuError(FinvuErrorCode.genericError, message);
    }
  }
}
