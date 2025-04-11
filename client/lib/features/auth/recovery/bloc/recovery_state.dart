part of 'recovery_bloc.dart';

enum RecoveryType { aaHandle, passcode }

enum RecoveryStatus {
  unknown,
  isSendingOtp,
  isResendingOtp,
  otpSent,
  isVerifyingOtp,
  userIdsFound,
  isLoggingIn,
  loggedIn,
  needAuthentication,
  connectionEstablished,
  error
}

final class RecoveryState extends Equatable {
  final String aaHandle;
  final List<String> userIds;
  final String mobileNumber;
  final String otp;
  final String newPasscode;
  final String confirmNewPasscode;
  final bool doesPasscodeMatch;

  final RecoveryStatus status;
  final RecoveryType type;

  final int errorTimestamp;
  final FinvuError? error;

  const RecoveryState({
    this.aaHandle = "",
    this.newPasscode = "",
    this.userIds = const [],
    this.confirmNewPasscode = "",
    this.doesPasscodeMatch = true,
    this.mobileNumber = "",
    this.otp = "",
    this.status = RecoveryStatus.unknown,
    this.type = RecoveryType.aaHandle,
    this.errorTimestamp = 0,
    this.error,
  });

  RecoveryState copyWith({
    String? aaHandle,
    String? newPasscode,
    String? confirmNewPasscode,
    bool? doesPasscodeMatch,
    String? mobileNumber,
    String? otp,
    List<String>? userIds,
    required RecoveryStatus status,
    RecoveryType? type,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == RecoveryStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }
    return RecoveryState(
      aaHandle: aaHandle ?? this.aaHandle,
      newPasscode: newPasscode ?? this.newPasscode,
      confirmNewPasscode: confirmNewPasscode ?? this.confirmNewPasscode,
      doesPasscodeMatch: doesPasscodeMatch ?? this.doesPasscodeMatch,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      userIds: userIds ?? this.userIds,
      otp: otp ?? this.otp,
      status: status,
      type: type ?? this.type,
      error: error ?? this.error,
      errorTimestamp: errorTimestamp,
    );
  }

  @override
  List<Object?> get props => [
        aaHandle,
        newPasscode,
        confirmNewPasscode,
        doesPasscodeMatch,
        mobileNumber,
        otp,
        status,
        type,
        error,
        errorTimestamp,
        userIds
      ];
}
