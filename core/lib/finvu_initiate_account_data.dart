class FinvuAccountData {
  FinvuAccountData({
    required this.version,
    required this.timestamp,
    required this.transactionId,
    required this.from,
    required this.to,
    required this.consentId,
    required this.digitalSignature,
    required this.cryptoAlgorithm,
    required this.curve,
    required this.params,
    required this.nonce,
    required this.signature,
    required this.publicKeyExpiry,
    required this.dhPublicKeyParameters,
    required this.dhPublicKeyValue,
  });

  String version;
  String timestamp;
  String transactionId;
  String from;
  String to;
  String consentId;
  String digitalSignature;
  String cryptoAlgorithm;
  String curve;
  String params;
  String nonce;
  String signature;
  String publicKeyExpiry;
  String dhPublicKeyParameters;
  String dhPublicKeyValue;
}

class FinvuAccountDataResponse {
  FinvuAccountDataResponse({
    required this.consentId,
    required this.transactionId,
    required this.sessionId,
    required this.timestamp,
  });
  String? consentId;
  String? timestamp;
  String? sessionId;
  String? transactionId;
}

class AccountDataFetchResponse {
  AccountDataFetchResponse({
    required this.fipId,
    required this.decryptedInfo,
  });
  String fipId;
  List<FIDecryptedDataInfo> decryptedInfo;
}

class FIDecryptedDataInfo {
  FIDecryptedDataInfo({
    required this.linkReferenceNumber,
    required this.accountReferenceNumber,
    required this.maskedAccountNumber,
    required this.fiType,
    required this.accountType,
    required this.decryptedData,
  });
  String linkReferenceNumber;
  String? accountReferenceNumber;
  String maskedAccountNumber;
  String? fiType;
  String? accountType;
  String decryptedData;
}
