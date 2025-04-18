part of 'consent_bloc.dart';

enum ConsentStatus {
  unknown,
  isFetchingConsentDetails,
  consentDetailsFetched,
  isFetchingLinkedAccounts,
  linkedAccountsFetched,
  isApprovingConsent,
  consentApproved,
  isRejectingConsent,
  consentRejected,
  isRevokingConsent,
  consentRevoked,
  selfConsentRequested,
  error,
}

class ConsentState extends Equatable {
  final ConsentStatus status;
  final int errorTimestamp;
  final FinvuConsentRequestDetailInfo? consent;
  final List<LinkedAccountInfo> linkedAccounts;
  final FinvuError? error;

  const ConsentState({
    this.status = ConsentStatus.unknown,
    this.errorTimestamp = 0,
    this.consent,
    this.linkedAccounts = const [],
    this.error,
  });

  ConsentState copyWith({
    ConsentStatus? status,
    List<LinkedAccountInfo>? linkedAccounts,
    FinvuConsentRequestDetailInfo? consent,
    List<FinvuConsentHistory>? consentHistory,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == ConsentStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    return ConsentState(
      status: status ?? this.status,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      consent: consent ?? this.consent,
      errorTimestamp: errorTimestamp,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorTimestamp,
        linkedAccounts,
        consent,
        error,
      ];
}
