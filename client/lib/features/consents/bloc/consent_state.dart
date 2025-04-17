part of 'consent_bloc.dart';

enum ConsentStatus {
  unknown,
  isFetchingConsents,
  consentsFetched,
  isFetchingLinkedAccounts,
  linkedAccountsFetched,
  isApprovingConsent,
  consentApproved,
  isRejectingConsent,
  consentRejected,
  isRevokingConsent,
  isRequestingSelfConsent,
  isFetchingHistory,
  historyFetched,
  consentRevoked,
  selfConsentRequested,
  error,
}

class ConsentState extends Equatable {
  final ConsentStatus status;
  final int errorTimestamp;
  final List<ConsentDetails> pendingConsents;
  final List<ConsentDetails> activeConsents;
  final List<ConsentDetails> inactiveConsents;
  final List<LinkedAccountInfo> linkedAccounts;
  final List<ConsentDetails> activeSelfConsents;
  final List<ConsentDetails> pausedConsnets;
  final List<ConsentDetails> expiringConsents;
  final FinvuError? error;
  final List<FinvuConsentHistory> consentHistory;

  const ConsentState({
    this.status = ConsentStatus.unknown,
    this.errorTimestamp = 0,
    this.pendingConsents = const [],
    this.linkedAccounts = const [],
    this.activeConsents = const [],
    this.inactiveConsents = const [],
    this.activeSelfConsents = const [],
    this.pausedConsnets = const [],
    this.expiringConsents = const [],
    this.consentHistory = const [],
    this.error,
  });

  ConsentState copyWith({
    ConsentStatus? status,
    List<ConsentDetails>? pendingConsents,
    List<LinkedAccountInfo>? linkedAccounts,
    List<ConsentDetails>? activeConsents,
    List<ConsentDetails>? inactiveConsents,
    List<ConsentDetails>? activeSelfConsents,
    List<ConsentDetails>? pausedConsnets,
    List<ConsentDetails>? expiringConsents,
    List<FinvuConsentHistory>? consentHistory,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == ConsentStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    return ConsentState(
      status: status ?? this.status,
      pendingConsents: pendingConsents ?? this.pendingConsents,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      activeConsents: activeConsents ?? this.activeConsents,
      inactiveConsents: inactiveConsents ?? this.inactiveConsents,
      activeSelfConsents: activeSelfConsents ?? this.activeSelfConsents,
      pausedConsnets: pausedConsnets ?? this.pausedConsnets,
      expiringConsents: expiringConsents ?? this.expiringConsents,
      errorTimestamp: errorTimestamp,
      consentHistory: consentHistory ?? this.consentHistory,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorTimestamp,
        pendingConsents,
        linkedAccounts,
        activeConsents,
        inactiveConsents,
        activeSelfConsents,
        expiringConsents,
        consentHistory,
        error,
      ];
}
