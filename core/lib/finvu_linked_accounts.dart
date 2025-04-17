class FinvuAccountLinkingRequestReference {
  FinvuAccountLinkingRequestReference({
    required this.referenceNumber,
  });
  String referenceNumber;
}

class FinvuLinkedAccountInfo {
  FinvuLinkedAccountInfo({
    required this.customerAddress,
    required this.linkReferenceNumber,
    required this.accountReferenceNumber,
    required this.status,
  });
  String customerAddress;
  String linkReferenceNumber;
  String accountReferenceNumber;
  String status;
}

class FinvuConfirmAccountLinkingInfo {
  FinvuConfirmAccountLinkingInfo({
    required this.linkedAccounts,
  });
  List<FinvuLinkedAccountInfo> linkedAccounts;
}

class FinvuLinkedAccountDetailsInfo {
  FinvuLinkedAccountDetailsInfo({
    required this.userId,
    required this.fipId,
    required this.fipName,
    required this.maskedAccountNumber,
    required this.accountReferenceNumber,
    required this.linkReferenceNumber,
    required this.consentIdList,
    required this.fiType,
    required this.accountType,
    required this.linkedAccountUpdateTimestamp,
    required this.authenticatorType,
  });
  String userId;
  String fipId;
  String fipName;
  String maskedAccountNumber;
  String accountReferenceNumber;
  String linkReferenceNumber;
  List<String>? consentIdList;
  String fiType;
  String accountType;
  DateTime? linkedAccountUpdateTimestamp;
  String authenticatorType;
}
