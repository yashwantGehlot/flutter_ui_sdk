class FinvuOfflineMessageInfo {
  FinvuOfflineMessageInfo({
    required this.userId,
    required this.messageId,
    required this.messageAcked,
    required this.messageOriginator,
    required this.messageOriginatorName,
    required this.messageText,
    required this.messageTimestamp,
    required this.messageType,
    required this.requestConsentId,
    required this.requestSessionId,
  });
  String userId;
  String messageId;
  String messageAcked;
  String messageOriginator;
  String? messageOriginatorName;
  String messageText;
  String messageTimestamp;
  String messageType;
  String requestConsentId;
  String? requestSessionId;
}
