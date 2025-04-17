class FinvuConsentHistory {
  FinvuConsentHistory({
    required this.consentId,
    required this.consentTimestamp,
  });
  String consentId;
  DateTime? consentTimestamp;
}

class FinvuConsentHistoryResponse {
  FinvuConsentHistoryResponse({
    required this.consentHistory,
  });
  List<FinvuConsentHistory>? consentHistory;
}
