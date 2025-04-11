part of 'registration_bloc.dart';

enum RegistrationStatus {
  unknown,
  isRegistering,
  success,
  emptyFields,
  error,
  connectionEstablished,
}

final class RegistrationState extends Equatable {
  final String mobileNumber;
  final String aaHandle;
  final String passcode;
  final String confirmPasscode;
  final bool doesPasscodeMatch;
  final bool didAcceptTerms;

  final RegistrationStatus status;

  final int errorTimestamp;

  const RegistrationState({
    this.aaHandle = "",
    this.mobileNumber = "",
    this.passcode = "",
    this.confirmPasscode = "",
    this.doesPasscodeMatch = true,
    this.didAcceptTerms = false,
    this.status = RegistrationStatus.unknown,
    this.errorTimestamp = 0,
  });

  RegistrationState copyWith({
    String? aaHandle,
    String? mobileNumber,
    String? passcode,
    String? confirmPasscode,
    bool? doesPasscodeMatch,
    bool? didAcceptTerms,
    required RegistrationStatus status,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == RegistrationStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }
    return RegistrationState(
      aaHandle: aaHandle ?? this.aaHandle,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      passcode: passcode ?? this.passcode,
      confirmPasscode: confirmPasscode ?? this.confirmPasscode,
      doesPasscodeMatch: doesPasscodeMatch ?? this.doesPasscodeMatch,
      didAcceptTerms: didAcceptTerms ?? this.didAcceptTerms,
      status: status,
      errorTimestamp: errorTimestamp,
    );
  }

  @override
  List<Object> get props => [
        aaHandle,
        mobileNumber,
        passcode,
        confirmPasscode,
        doesPasscodeMatch,
        didAcceptTerms,
        status,
        errorTimestamp,
      ];
}
