class FinvuFinancialInformationEntityInfo {
  FinvuFinancialInformationEntityInfo({
    required this.id,
    required this.name,
  });

  String id;
  String name;
}

class FinvuConsentPurposeInfo {
  FinvuConsentPurposeInfo({
    required this.code,
    required this.text,
  });

  String code;
  String text;
}

class FinvuConsentRequestDetailInfo {
  FinvuConsentRequestDetailInfo({
    required this.consentId,
    required this.consentHandle,
    required this.statusLastUpdateTimestamp,
    required this.financialInformationUser,
    required this.consentPurposeInfo,
    required this.consentDisplayDescriptions,
    required this.dataDateTimeRange,
    required this.consentDateTimeRange,
    required this.consentDataFrequency,
    required this.consentDataLifePeriod,
    required this.fiTypes,
  });

  String consentHandle;
  String? consentId;
  FinvuFinancialInformationEntityInfo financialInformationUser;
  FinvuConsentPurposeInfo consentPurposeInfo;
  List<String> consentDisplayDescriptions;
  FinvuDateTimeRange dataDateTimeRange;
  FinvuDateTimeRange consentDateTimeRange;
  FinvuConsentDataFrequency consentDataFrequency;
  FinvuConsentDataLifePeriod consentDataLifePeriod;
  List<String>? fiTypes;
  DateTime? statusLastUpdateTimestamp;
}

class FinvuDateTimeRange {
  FinvuDateTimeRange({
    required this.from,
    required this.to,
  });

  DateTime? from;
  DateTime? to;
}

class FinvuConsentInfo {
  FinvuConsentInfo({
    required this.consentId,
    required this.fipId,
  });

  String consentId;
  String? fipId;
}

class FinvuProcessConsentRequestResponse {
  FinvuProcessConsentRequestResponse({
    required this.consentIntentId,
    required this.consentInfo,
  });

  String? consentIntentId;
  List<FinvuConsentInfo>? consentInfo;
}

class FinvuConsentDataFrequency {
  FinvuConsentDataFrequency({
    required this.unit,
    required this.value,
  });

  String unit;
  double value;
}

class FinvuConsentDataLifePeriod {
  FinvuConsentDataLifePeriod({
    required this.unit,
    required this.value,
  });

  String unit;
  double value;
}

class FinvuEntityInfo {
  FinvuEntityInfo({
    required this.entityId,
    required this.entityName,
    required this.entityIconUri,
    required this.entityLogoUri,
    required this.entityLogoWithNameUri,
  });

  String entityId;
  String entityName;
  String? entityIconUri;
  String? entityLogoUri;
  String? entityLogoWithNameUri;
}

class FinvuUserConsentInfo {
  FinvuUserConsentInfo({
    required this.consentIntentId,
    required this.consentIntentEntityId,
    required this.consentIntentEntityName,
    required this.consentIdList,
    required this.consentIntentUpdateTimestamp,
    required this.consentPurposeText,
    required this.status,
  });

  String consentIntentId;
  String? consentIntentEntityId;
  String consentIntentEntityName;
  List<String> consentIdList;
  DateTime? consentIntentUpdateTimestamp;
  String consentPurposeText;
  String? status;
}

class FinvuConsentAccountDetails {
  FinvuConsentAccountDetails({
    required this.accountReferenceNumber,
    required this.maskedAccountNumber,
    required this.fiType,
    required this.accountType,
    required this.linkReferenceNumber,
    required this.fipId,
    required this.fipName,
  });

  String fiType;
  String fipId;
  String fipName;
  String accountType;
  String? accountReferenceNumber;
  String maskedAccountNumber;
  String linkReferenceNumber;
}

class FinvuConsentInfoDetails {
  FinvuConsentInfoDetails({
    required this.consentHandle,
    required this.consentId,
    required this.statusLastUpdateTimestamp,
    required this.consentStatus,
    required this.consentDateTimeRange,
    required this.consentDataFrequency,
    required this.consentDataLifePeriod,
    required this.consentDisplayDescriptions,
    required this.financialInformationProvider,
    required this.financialInformationUser,
    required this.consentPurposeInfo,
    required this.dataDateTimeRange,
    required this.accounts,
    this.finvuUserConsentInfo,
    required this.fiTypes,
    this.accountAggregator,
  });

  String? consentHandle;
  String? consentId;
  FinvuFinancialInformationEntityInfo? financialInformationProvider;
  FinvuFinancialInformationEntityInfo? financialInformationUser;
  FinvuConsentPurposeInfo consentPurposeInfo;
  List<String> consentDisplayDescriptions;
  FinvuDateTimeRange dataDateTimeRange;
  FinvuDateTimeRange consentDateTimeRange;
  FinvuConsentDataLifePeriod consentDataLifePeriod;
  FinvuConsentDataFrequency consentDataFrequency;
  FinvuUserConsentInfo? finvuUserConsentInfo;
  DateTime? statusLastUpdateTimestamp;
  String consentStatus;
  List<FinvuConsentAccountDetails> accounts;
  List<String>? fiTypes;
  AccountAggregator? accountAggregator;
}

class AccountAggregator {
  AccountAggregator({
    this.id,
  });

  String? id;
}

class FIPReference {
  FIPReference({
    required this.fipId,
    required this.fipName,
  });

  String fipId;
  String fipName;
}

class FinvuLoginOtpReference {
  FinvuLoginOtpReference({
    required this.reference,
  });

  String reference;
}

class FinvuConsentHandleStatusResponse {
  FinvuConsentHandleStatusResponse({
    required this.status,
  });

  String status;
}
