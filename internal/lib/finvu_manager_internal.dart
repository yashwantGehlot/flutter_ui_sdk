import 'package:finvu_flutter_sdk_core/finvu_consent_history.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_report.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_forgot_handle.dart';
import 'package:finvu_flutter_sdk_core/finvu_linked_accounts.dart';
import 'package:finvu_flutter_sdk_core/finvu_offline_messages.dart';
import 'package:finvu_flutter_sdk_core/finvu_user_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_initiate_account_data.dart';
import 'package:finvu_flutter_sdk_internal/finvu_device_binding.dart';
import 'package:finvu_flutter_sdk_internal/finvu_login_response.dart';
import 'package:finvu_flutter_sdk_internal/generated/native_finvu_manager_internal.g.dart';
import 'package:flutter/services.dart';

class FinvuManagerInternal {
  final _nativeFinvuManagerInternal = NativeFinvuManagerInternal();

  static final FinvuManagerInternal _instance =
      FinvuManagerInternal._internal();

  factory FinvuManagerInternal() {
    return _instance;
  }

  FinvuManagerInternal._internal();

  get _platformExceptionTest => (e) => e is PlatformException;

  Future<FinvuLoginResponse> loginWithUsernameAndPasscode(
      String username, String passcode, String? totp, String? deviceId) {
    return _nativeFinvuManagerInternal
        .loginWithUsernameAndPasscode(username, passcode, totp, deviceId)
        .then((response) =>
            FinvuLoginResponse(deviceBindingValid: response.deviceBindingValid))
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> initiateForgotPasscodeRequest(
      String username, String mobileNumber) {
    return _nativeFinvuManagerInternal
        .initiateForgotPasscodeRequest(
          username,
          mobileNumber,
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuDeviceBinding> deviceBindingRequest(
    String otpLessToken,
    String deviceId,
    String osType,
    String osVersion,
    String appId,
    String appVersion,
    String? simSerialNumber,
  ) {
    return _nativeFinvuManagerInternal
        .deviceBinding(
          otpLessToken,
          deviceId,
          osType,
          osVersion,
          appId,
          appVersion,
          simSerialNumber,
        )
        .then(
          (response) => FinvuDeviceBinding(
            secret: response.secret,
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> verifyForgotPasscodeOTP(
    String username,
    String mobileNumber,
    String otp,
    String newPasscode,
  ) {
    return _nativeFinvuManagerInternal
        .verifyForgotPasscodeOTP(
          username,
          mobileNumber,
          otp,
          newPasscode,
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> initiateForgotHandleRequest(String mobileNumber) {
    return _nativeFinvuManagerInternal
        .initiateForgotHandleRequest(mobileNumber)
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuForgotHandle> verifyForgotHandleOTP(String otp) {
    return _nativeFinvuManagerInternal
        .verifyForgotHandleOTP(otp)
        .then((response) =>
            FinvuForgotHandle(userIds: response.userIds.nonNulls.toList()))
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> register(String username, String mobileNumber, String passcode) {
    return _nativeFinvuManagerInternal
        .register(username, mobileNumber, passcode)
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuUserInfo> fetchUserInfo() {
    return _nativeFinvuManagerInternal
        .fetchUserInfo()
        .then(
          (userInfo) => FinvuUserInfo(
              userId: userInfo.userId,
              mobileNumber: userInfo.mobileNumber,
              emailId: userInfo.emailId),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> unlinkAccount(FinvuLinkedAccountDetailsInfo account) {
    final nativeAccount = NativeLinkedAccountDetailsInfoInternal(
      userId: account.userId,
      fipId: account.fipId,
      fipName: account.fipName,
      maskedAccountNumber: account.maskedAccountNumber,
      accountReferenceNumber: account.accountReferenceNumber,
      linkReferenceNumber: account.linkReferenceNumber,
      consentIdList: account.consentIdList,
      fiType: account.fiType,
      accountType: account.accountType,
      linkedAccountUpdateTimestamp:
          account.linkedAccountUpdateTimestamp?.toIso8601String(),
      authenticatorType: account.authenticatorType,
    );
    return _nativeFinvuManagerInternal.unlinkAccount(nativeAccount).catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<List<FinvuUserConsentInfo>> getUserConsents() {
    return _nativeFinvuManagerInternal
        .getUserConsents()
        .then(
          (response) => response.userConsents.nonNulls
              .map(
                (consentInfo) => FinvuUserConsentInfo(
                  consentIntentId: consentInfo.consentIntentId,
                  consentIntentEntityId: consentInfo.consentIntentEntityId,
                  consentIdList: consentInfo.consentIdList.nonNulls.toList(),
                  consentIntentEntityName: consentInfo.consentIntentEntityName,
                  consentIntentUpdateTimestamp: DateTime.tryParse(
                      consentInfo.consentIntentUpdateTimestamp),
                  consentPurposeText: consentInfo.consentPurposeText,
                  status: consentInfo.status,
                ),
              )
              .toList(),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuConsentInfoDetails> getUserConsentDetails(
    FinvuUserConsentInfo consent,
  ) {
    final nativeConsent = NativeUserConsentInfoInternal(
      consentIntentId: consent.consentIntentId,
      consentIntentEntityId: consent.consentIntentEntityId,
      consentIdList: consent.consentIdList,
      consentIntentEntityName: consent.consentIntentEntityName,
      consentIntentUpdateTimestamp:
          consent.consentIntentUpdateTimestamp?.toIso8601String() ?? "",
      consentPurposeText: consent.consentPurposeText,
      status: consent.status,
    );

    return _nativeFinvuManagerInternal
        .getUserConsentDetails(nativeConsent)
        .then(
          (consentDetails) => _getConsentInfoDetails(consentDetails),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<List<FinvuOfflineMessageInfo>> fetchOfflineMessages() {
    return _nativeFinvuManagerInternal
        .fetchOfflineMessages()
        .then(
          (value) => value.offlineMessageInfo.nonNulls
              .map(
                (account) => FinvuOfflineMessageInfo(
                  userId: account.userId,
                  messageId: account.messageId,
                  messageAcked: account.messageAcked,
                  messageOriginator: account.messageOriginator,
                  messageOriginatorName: account.messageOriginatorName,
                  messageText: account.messageText,
                  messageTimestamp: account.messageTimestamp,
                  messageType: account.messageType,
                  requestConsentId: account.requestConsentId,
                  requestSessionId: account.requestSessionId,
                ),
              )
              .toList(),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> closeFinvuAccount(String pasword) {
    return _nativeFinvuManagerInternal.closeFinvuAccount(pasword).catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> changePasscodeRequest(
    String currentPasscode,
    String newPasscode,
  ) {
    return _nativeFinvuManagerInternal
        .changePasscode(
          currentPasscode,
          newPasscode,
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuConsentReport> getUserConsentReport() {
    return _nativeFinvuManagerInternal
        .getUserConsentReport()
        .then(
          (consentReport) => FinvuConsentReport(report: consentReport.report),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  FinvuConsentInfoDetails _getConsentInfoDetails(
      NativeConsentInfoDetailsInternal consentDetails) {
    return FinvuConsentInfoDetails(
        consentId: consentDetails.consentId,
        consentHandle: consentDetails.consentHandle,
        consentStatus: consentDetails.consentStatus,
        statusLastUpdateTimestamp:
            consentDetails.statusLastUpdateTimestamp != null
                ? DateTime.tryParse(consentDetails.statusLastUpdateTimestamp!)
                : null,
        consentDateTimeRange: FinvuDateTimeRange(
          from: DateTime.tryParse(consentDetails.consentDateTimeRange.from),
          to: DateTime.tryParse(consentDetails.consentDateTimeRange.to),
        ),
        consentDataFrequency: FinvuConsentDataFrequency(
          unit: consentDetails.consentDataFrequency.unit,
          value: consentDetails.consentDataFrequency.value,
        ),
        consentDataLifePeriod: FinvuConsentDataLifePeriod(
          unit: consentDetails.consentDataLifePeriod.unit,
          value: consentDetails.consentDataLifePeriod.value,
        ),
        consentDisplayDescriptions:
            consentDetails.consentDisplayDescriptions.nonNulls.toList(),
        financialInformationProvider:
            consentDetails.financialInformationProvider != null
                ? FinvuFinancialInformationEntityInfo(
                    id: consentDetails.financialInformationProvider!.id,
                    name: consentDetails.financialInformationProvider!.name,
                  )
                : null,
        financialInformationUser:
            consentDetails.financialInformationUser != null
                ? FinvuFinancialInformationEntityInfo(
                    id: consentDetails.financialInformationUser!.id,
                    name: consentDetails.financialInformationUser!.name,
                  )
                : null,
        consentPurposeInfo: FinvuConsentPurposeInfo(
          code: consentDetails.consentPurpose.code,
          text: consentDetails.consentPurpose.text,
        ),
        dataDateTimeRange: FinvuDateTimeRange(
          from: DateTime.tryParse(consentDetails.dataDateTimeRange.from),
          to: DateTime.tryParse(consentDetails.dataDateTimeRange.to),
        ),
        accounts: consentDetails.accounts.nonNulls
            .map(
              (account) => FinvuConsentAccountDetails(
                  accountReferenceNumber: account.accountReferenceNumber,
                  maskedAccountNumber: account.maskedAccountNumber,
                  fiType: account.fiType,
                  accountType: account.accountType,
                  linkReferenceNumber: account.linkReferenceNumber,
                  fipId: account.fipId,
                  fipName: ""),
            )
            .toList(),
        fiTypes: consentDetails.fiTypes?.nonNulls.toList(),
        accountAggregator:
            AccountAggregator(id: consentDetails.accountAggregator?.id));
  }

  Future<List<FinvuConsentRequestDetailInfo>> fetchPendingConsents() {
    return _nativeFinvuManagerInternal
        .fetchPendingConsentRequests()
        .then(
          (value) => value.details.nonNulls
              .map(
                (consentRequest) => FinvuConsentRequestDetailInfo(
                  consentId: consentRequest.consentId,
                  consentHandle: consentRequest.consentHandleId,
                  statusLastUpdateTimestamp:
                      consentRequest.statusLastUpdateTimestamp != null
                          ? DateTime.tryParse(
                              consentRequest.statusLastUpdateTimestamp!)
                          : null,
                  financialInformationUser: FinvuFinancialInformationEntityInfo(
                    id: consentRequest.financialInformationUser.id,
                    name: consentRequest.financialInformationUser.name,
                  ),
                  consentPurposeInfo: FinvuConsentPurposeInfo(
                    code: consentRequest.consentPurposeInfo.code,
                    text: consentRequest.consentPurposeInfo.text,
                  ),
                  consentDisplayDescriptions: consentRequest
                      .consentDisplayDescriptions.nonNulls
                      .toList(),
                  dataDateTimeRange: FinvuDateTimeRange(
                    from: DateTime.tryParse(
                        consentRequest.dataDateTimeRange.from),
                    to: DateTime.tryParse(consentRequest.dataDateTimeRange.to),
                  ),
                  consentDateTimeRange: FinvuDateTimeRange(
                    from: DateTime.tryParse(
                        consentRequest.consentDateTimeRange.from),
                    to: DateTime.tryParse(
                        consentRequest.consentDateTimeRange.to),
                  ),
                  consentDataFrequency: FinvuConsentDataFrequency(
                    unit: consentRequest.consentDataFrequency.unit,
                    value: consentRequest.consentDataFrequency.value,
                  ),
                  consentDataLifePeriod: FinvuConsentDataLifePeriod(
                    unit: consentRequest.consentDataLifePeriod.unit,
                    value: consentRequest.consentDataLifePeriod.value,
                  ),
                  fiTypes: consentRequest.fiTypes?.nonNulls.toList(),
                ),
              )
              .toList(),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuConsentInfoDetails> getUserConsentDetailsForId(String consentId) {
    return _nativeFinvuManagerInternal
        .getUserConsentDetailsForId(consentId)
        .then(
          (consentDetails) => _getConsentInfoDetails(consentDetails),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuConsentHistoryResponse> getConsentHistory(
    String consentId,
  ) {
    return _nativeFinvuManagerInternal
        .getConsentHistory(consentId)
        .then(
          (response) => FinvuConsentHistoryResponse(
            consentHistory: response.consentHistory?.nonNulls
                .map(
                  (consentInfo) => FinvuConsentHistory(
                    consentId: consentInfo.consentId,
                    consentTimestamp:
                        DateTime.tryParse(consentInfo.consentTimestamp!),
                  ),
                )
                .toList(),
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> requestSelfConsent(
    DateTime createTime,
    DateTime startTime,
    DateTime expireTime,
    List<FinvuLinkedAccountDetailsInfo> linkedAccounts,
    List<String> consentTypes,
    List<String> consentFiTypes,
    String mode,
    String fetchType,
    FinvuConsentDataFrequency frequency,
    FinvuConsentDataLifePeriod dataLife,
    String purposeText,
    String purposeType,
  ) {
    final accounts = linkedAccounts
        .map(
          (account) => NativeLinkedAccountDetailsInfoInternal(
              userId: account.userId,
              fipId: account.fipId,
              fipName: account.fipName,
              maskedAccountNumber: account.maskedAccountNumber,
              accountReferenceNumber: account.accountReferenceNumber,
              linkReferenceNumber: account.linkReferenceNumber,
              fiType: account.fiType,
              accountType: account.accountType,
              authenticatorType: account.authenticatorType),
        )
        .toList();
    return _nativeFinvuManagerInternal
        .requestSelfConsent(
          NativeSelfConsentRequestInternal(
            createTime: createTime.toUtc().toIso8601String(),
            startTime: startTime.toUtc().toIso8601String(),
            expireTime: expireTime.toUtc().toIso8601String(),
            linkedAccounts: accounts,
            consentTypes: consentTypes,
            consentFiTypes: consentFiTypes,
            mode: mode,
            fetchType: fetchType,
            frequency: NativeConsentDataFrequencyInternal(
              unit: frequency.unit,
              value: frequency.value,
            ),
            dataLife: NativeConsentDataLifePeriodInternal(
              unit: dataLife.unit,
              value: dataLife.value,
            ),
            purposeText: purposeText,
            purposeType: purposeType,
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuAccountDataResponse> initiateAccountDataRequest(
    String from,
    String to,
    String consentId,
    String publicKeyExpiry,
  ) {
    return _nativeFinvuManagerInternal
        .initiateAccountDataRequest(from, to, consentId, publicKeyExpiry)
        .then((response) => FinvuAccountDataResponse(
            consentId: response.consentId,
            transactionId: response.transactionId,
            sessionId: response.sessionId,
            timestamp: response.timestamp))
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<AccountDataFetchResponse> fetchAccountData(
    String sessionId,
    String consentId,
  ) {
    return _nativeFinvuManagerInternal
        .fetchAccountData(sessionId, consentId)
        .then(
          (response) => AccountDataFetchResponse(
            fipId: response.fipId,
            decryptedInfo: response.decryptedInfo.nonNulls
                .map((data) => FIDecryptedDataInfo(
                    linkReferenceNumber: data.linkReferenceNumber,
                    accountReferenceNumber: data.accountReferenceNumber,
                    maskedAccountNumber: data.maskedAccountNumber,
                    fiType: data.fiType,
                    accountType: data.accountType,
                    decryptedData: data.decryptedData))
                .toList(),
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }
}
