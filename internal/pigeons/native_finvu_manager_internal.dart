import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/generated/native_finvu_manager_internal.g.dart',
    kotlinOut:
        'android/src/main/kotlin/com/finvu/finvu_flutter_sdk_internal/generated/NativeFinvuManagerInternal.g.kt',
    swiftOut: 'ios/Classes/generated/NativeFinvuManagerInternal.g.swift',
    kotlinOptions: KotlinOptions(errorClassName: 'NativeFinvuErrorInternal'),
  ),
)
class NativeHandleInfoInternal {
  NativeHandleInfoInternal({required this.userId});
  String userId;
}

class NativeForgotHandleInternal {
  NativeForgotHandleInternal({required this.userIds});
  List<String?> userIds;
}

class NativeLoginResponse {
  bool? deviceBindingValid;
}

class NativeDeviceBindingResponse {
  String? secret;
}

class NativeUserInfoInternal {
  NativeUserInfoInternal({
    required this.userId,
    required this.mobileNumber,
    required this.emailId,
  });
  String userId;
  String mobileNumber;
  String emailId;
}

class NativeLinkedAccountDetailsInfoInternal {
  NativeLinkedAccountDetailsInfoInternal({
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
  List<String?>? consentIdList;
  String fiType;
  String accountType;
  String? linkedAccountUpdateTimestamp;
  String authenticatorType;
}

class NativeUserConsentInfoInternal {
  NativeUserConsentInfoInternal({
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
  List<String?> consentIdList;
  String consentIntentUpdateTimestamp;
  String consentPurposeText;
  String? status;
}

class NativeUserConsentResponseInternal {
  NativeUserConsentResponseInternal({
    required this.userConsents,
  });

  List<NativeUserConsentInfoInternal?> userConsents;
}

class NativeFinancialInformationEntityInternal {
  NativeFinancialInformationEntityInternal({
    required this.id,
    required this.name,
  });

  String id;
  String name;
}

class NativeConsentPurposeInfoInternal {
  NativeConsentPurposeInfoInternal({
    required this.code,
    required this.text,
  });

  String code;
  String text;
}

class NativeDateTimeRangeInternal {
  NativeDateTimeRangeInternal({
    required this.from,
    required this.to,
  });

  String from;
  String to;
}

class NativeConsentDataFrequencyInternal {
  NativeConsentDataFrequencyInternal({
    required this.unit,
    required this.value,
  });

  String unit;
  double value;
}

class NativeConsentDataLifePeriodInternal {
  NativeConsentDataLifePeriodInternal({
    required this.unit,
    required this.value,
  });

  String unit;
  double value;
}

class NativeConsentAccountDetailsInternal {
  NativeConsentAccountDetailsInternal({
    required this.accountReferenceNumber,
    required this.maskedAccountNumber,
    required this.fiType,
    required this.accountType,
    required this.linkReferenceNumber,
    required this.fipId,
  });

  String fiType;
  String fipId;
  String accountType;
  String? accountReferenceNumber;
  String maskedAccountNumber;
  String linkReferenceNumber;
}

class NativeConsentInfoDetailsInternal {
  NativeConsentInfoDetailsInternal(
      {required this.consentHandle,
      required this.consentId,
      required this.statusLastUpdateTimestamp,
      required this.consentStatus,
      required this.consentDateTimeRange,
      required this.consentDataFrequency,
      required this.consentDataLifePeriod,
      required this.consentDisplayDescriptions,
      required this.financialInformationUser,
      required this.consentPurpose,
      required this.dataDateTimeRange,
      required this.accounts,
      required this.fiTypes,
      this.accountAggregator});

  String? consentHandle;
  String? consentId;
  String consentStatus;
  NativeFinancialInformationEntityInternal? financialInformationProvider;
  NativeFinancialInformationEntityInternal? financialInformationUser;
  NativeConsentPurposeInfoInternal consentPurpose;
  List<String?> consentDisplayDescriptions;
  NativeDateTimeRangeInternal dataDateTimeRange;
  NativeDateTimeRangeInternal consentDateTimeRange;
  NativeConsentDataLifePeriodInternal consentDataLifePeriod;
  NativeConsentDataFrequencyInternal consentDataFrequency;
  List<NativeConsentAccountDetailsInternal?> accounts;
  List<String?>? fiTypes;
  NativeAccountAggregatorInternal? accountAggregator;
  String? statusLastUpdateTimestamp;
}

class NativeAccountAggregatorInternal {
  NativeAccountAggregatorInternal({
    required this.id,
  });
  String id;
}

class NativeFetchOfflineMessageResponseInternal {
  NativeFetchOfflineMessageResponseInternal({
    required this.offlineMessageInfo,
  });
  List<NativeOfflineMessageInfoInternal?> offlineMessageInfo;
}

class NativeOfflineMessageInfoInternal {
  NativeOfflineMessageInfoInternal({
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

class NativeConsentReportInternal {
  NativeConsentReportInternal({required this.report});
  String report;
}

class NativePendingConsentRequestsResponseInternal {
  NativePendingConsentRequestsResponseInternal({
    required this.details,
  });

  List<NativeConsentRequestDetailInfoInternal?> details;
}

class NativeConsentRequestDetailInfoInternal {
  NativeConsentRequestDetailInfoInternal({
    required this.consentHandleId,
    required this.consentId,
    required this.financialInformationUser,
    required this.consentPurposeInfo,
    required this.consentDisplayDescriptions,
    required this.dataDateTimeRange,
    required this.consentDateTimeRange,
    required this.consentDataFrequency,
    required this.consentDataLifePeriod,
    required this.fiTypes,
    required this.statusLastUpdateTimestamp,
  });

  String consentHandleId;
  String? consentId;
  NativeFinancialInformationEntityInternal financialInformationUser;
  NativeConsentPurposeInfoInternal consentPurposeInfo;
  List<String?> consentDisplayDescriptions;
  NativeDateTimeRangeInternal dataDateTimeRange;
  NativeDateTimeRangeInternal consentDateTimeRange;
  NativeConsentDataFrequencyInternal consentDataFrequency;
  NativeConsentDataLifePeriodInternal consentDataLifePeriod;
  List<String?>? fiTypes;
  String? statusLastUpdateTimestamp;
}

class NativeSelfConsentRequestInternal {
  NativeSelfConsentRequestInternal({
    required this.createTime,
    required this.startTime,
    required this.expireTime,
    required this.linkedAccounts,
    required this.consentTypes,
    required this.consentFiTypes,
    required this.mode,
    required this.fetchType,
    required this.frequency,
    required this.dataLife,
    required this.purposeText,
    required this.purposeType,
  });

  String createTime;
  String startTime;
  String expireTime;
  List<NativeLinkedAccountDetailsInfoInternal?> linkedAccounts;
  List<String?> consentTypes;
  List<String?> consentFiTypes;
  String mode;
  String fetchType;
  NativeConsentDataFrequencyInternal frequency;
  NativeConsentDataLifePeriodInternal dataLife;
  String purposeText;
  String purposeType;
}

class NativeConsentHistoryInternal {
  NativeConsentHistoryInternal({
    required this.consentId,
    required this.consentTimestamp,
  });
  String consentId;
  String? consentTimestamp;
}

class NativeAccountDataInternal {
  NativeAccountDataInternal({
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

class NativeAccountDataFetchInternal {
  NativeAccountDataFetchInternal({
    required this.fipId,
    required this.decryptedInfo,
  });
  String fipId;
  List<NativeFIDecryptedDataInfoInternal?> decryptedInfo;
}

class NativeFIDecryptedDataInfoInternal {
  NativeFIDecryptedDataInfoInternal({
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

class NativeConsentHistoryResponseInternal {
  NativeConsentHistoryResponseInternal({
    required this.consentHistory,
  });
  List<NativeConsentHistoryInternal?>? consentHistory;
}

@HostApi()
abstract class NativeFinvuManagerInternal {
  @async
  NativeLoginResponse loginWithUsernameAndPasscode(
    String username,
    String passcode,
    String? totp,
    String? deviceId,
  );

  @async
  NativeDeviceBindingResponse deviceBinding(
    String otpLessToken,
    String deviceId,
    String osType,
    String osVersion,
    String appId,
    String appVersion,
    String? simSerialNumber,
  );

  @async
  void initiateForgotPasscodeRequest(
    String username,
    String mobileNumber,
  );

  @async
  void verifyForgotPasscodeOTP(
    String username,
    String mobileNumber,
    String otp,
    String newPasscode,
  );

  @async
  void initiateForgotHandleRequest(String mobileNumber);

  @async
  NativeForgotHandleInternal verifyForgotHandleOTP(
    String otp,
  );

  @async
  void register(
    String username,
    String mobileNumber,
    String passcode,
  );

  @async
  NativeUserInfoInternal fetchUserInfo();

  @async
  void unlinkAccount(NativeLinkedAccountDetailsInfoInternal account);

  @async
  NativeUserConsentResponseInternal getUserConsents();

  @async
  NativeConsentInfoDetailsInternal getUserConsentDetails(
      NativeUserConsentInfoInternal consent);

  @async
  NativeFetchOfflineMessageResponseInternal fetchOfflineMessages();

  @async
  void closeFinvuAccount(String password);

  @async
  void changePasscode(
    String currentPasscode,
    String newPasscode,
  );

  @async
  NativeConsentReportInternal getUserConsentReport();

  @async
  NativePendingConsentRequestsResponseInternal fetchPendingConsentRequests();

  @async
  NativeConsentInfoDetailsInternal getUserConsentDetailsForId(String consentId);

  @async
  NativeConsentHistoryResponseInternal getConsentHistory(String consentId);

  @async
  NativeAccountDataInternal initiateAccountDataRequest(
      String from, String to, String consentId, String publicKeyExpiry);

  @async
  void requestSelfConsent(NativeSelfConsentRequestInternal request);

  @async
  NativeAccountDataFetchInternal fetchAccountData(
      String sessionId, String consentId);
}
