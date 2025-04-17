part of 'consent_bloc.dart';

sealed class ConsentEvent {
  const ConsentEvent();
}

final class ConsentsRefresh extends ConsentEvent {
  const ConsentsRefresh();
}

final class LinkedAccountsRefresh extends ConsentEvent {
  const LinkedAccountsRefresh();
}

final class ConsentApprove extends ConsentEvent {
  const ConsentApprove({
    required this.consent,
    required this.selectedAccounts,
  });

  final ConsentDetails consent;
  final List<LinkedAccountInfo> selectedAccounts;
}

final class ConsentReject extends ConsentEvent {
  const ConsentReject({required this.consent});

  final ConsentDetails consent;
}

final class ConsentRevoke extends ConsentEvent {
  const ConsentRevoke({required this.consent});

  final ConsentDetails consent;
}

final class SelfConsentRequest extends ConsentEvent {
  const SelfConsentRequest({required this.selfConsentDetails});

  final SelfConsentDetails selfConsentDetails;
}

final class ConsentHistory extends ConsentEvent {
  const ConsentHistory({required this.consent});

  final ConsentDetails consent;
}
