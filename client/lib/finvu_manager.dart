import 'package:finvu_flutter_sdk/finvu_config.dart';
import 'package:finvu_flutter_sdk/generated/native_finvu_manager.g.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_discovered_accounts.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_details.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_handle_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_linked_accounts.dart';
import 'package:flutter/services.dart';

class FinvuManager {
  final _nativeFinvuManager = NativeFinvuManager();

  static final FinvuManager _instance = FinvuManager._internal();

  factory FinvuManager() {
    return _instance;
  }

  FinvuManager._internal();

  get _platformExceptionTest => (e) => e is PlatformException;

  void initialize(final FinvuConfig config) {
    final NativeFinvuConfig nativeFinvuConfig = NativeFinvuConfig(
      finvuEndpoint: config.finvuEndpoint,
      certificatePins: config.certificatePins,
    );
    _nativeFinvuManager.initialize(nativeFinvuConfig);
  }

  Future<void> connect() {
    return _nativeFinvuManager.connect().catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  void disconnect() {
    _nativeFinvuManager.disconnect();
  }

  Future<bool> isConnected() {
    return _nativeFinvuManager.isConnected().catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<bool> hasSession() {
    return _nativeFinvuManager.hasSession();
  }

  Future<FinvuLoginOtpReference>
      loginWithUsernameOrMobileNumberAndConsentHandle(
    String? username,
    String? mobileNumber,
    String consentHandleId,
  ) {
    return _nativeFinvuManager
        .loginWithUsernameOrMobileNumberAndConsentHandle(
          username,
          mobileNumber,
          consentHandleId,
        )
        .then(
          (otpReference) => FinvuLoginOtpReference(
            reference: otpReference.reference,
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuHandleInfo> verifyLoginOtp(
    String otp,
    String otpReference,
  ) {
    return _nativeFinvuManager
        .verifyLoginOtp(otp, otpReference)
        .then(
          (handleInfo) => FinvuHandleInfo(userId: handleInfo.userId),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<List<FinvuDiscoveredAccountInfo>> discoverAccounts(
    String fipId,
    List<String> fiTypes,
    List<FinvuTypeIdentifierInfo> identifiers,
  ) {
    final List<NativeTypeIdentifierInfo> nativeTypeIdentifierInfo = identifiers
        .map(
          (identifier) => NativeTypeIdentifierInfo(
            category: identifier.category,
            type: identifier.type,
            value: identifier.value,
          ),
        )
        .toList();

    return _nativeFinvuManager
        .discoverAccounts(fipId, fiTypes, nativeTypeIdentifierInfo)
        .then(
          (response) => response.accounts.nonNulls
              .map(
                (account) => FinvuDiscoveredAccountInfo(
                  accountType: account.accountType,
                  accountReferenceNumber: account.accountReferenceNumber,
                  maskedAccountNumber: account.maskedAccountNumber,
                  fiType: account.fiType,
                ),
              )
              .toList(),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<List<FinvuDiscoveredAccountInfo>> discoverAccountsAsync(
    String fipId,
    List<String> fiTypes,
    List<FinvuTypeIdentifierInfo> identifiers,
  ) {
    final List<NativeTypeIdentifierInfo> nativeTypeIdentifierInfo = identifiers
        .map(
          (identifier) => NativeTypeIdentifierInfo(
            category: identifier.category,
            type: identifier.type,
            value: identifier.value,
          ),
        )
        .toList();

    return _nativeFinvuManager
        .discoverAccountsAsync(fipId, fiTypes, nativeTypeIdentifierInfo)
        .then(
          (response) => response.accounts.nonNulls
              .map(
                (account) => FinvuDiscoveredAccountInfo(
                  accountType: account.accountType,
                  accountReferenceNumber: account.accountReferenceNumber,
                  maskedAccountNumber: account.maskedAccountNumber,
                  fiType: account.fiType,
                ),
              )
              .toList(),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<List<FinvuFIPInfo>> fipsAllFIPOptions() {
    return _nativeFinvuManager
        .fipsAllFIPOptions()
        .then(
          (searchResponse) => searchResponse.searchOptions.nonNulls
              .map(
                (fipInfo) => FinvuFIPInfo(
                  fipId: fipInfo.fipId,
                  productName: fipInfo.productName,
                  fipFitypes: fipInfo.fipFitypes.nonNulls.toList(),
                  productDesc: fipInfo.productDesc,
                  productIconUri: fipInfo.productIconUri,
                  enabled: fipInfo.enabled,
                ),
              )
              .toList(),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuFIPDetails> fetchFIPDetails(String fipId) {
    return _nativeFinvuManager
        .fetchFIPDetails(fipId)
        .then(
          (fipDetails) => FinvuFIPDetails(
            fipId: fipDetails.fipId,
            typeIdentifiers: fipDetails.typeIdentifiers.nonNulls
                .map(
                  (fipFiTypeIdentifier) => FinvuFIPFiTypeIdentifier(
                    fiType: fipFiTypeIdentifier.fiType,
                    identifiers: fipFiTypeIdentifier.identifiers.nonNulls
                        .map(
                          (typeIdentifier) => FinvuTypeIdentifier(
                            type: typeIdentifier.type,
                            category: typeIdentifier.category,
                          ),
                        )
                        .toList(),
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

  Future<FinvuEntityInfo> getEntityInfo(String entityId, String entityType) {
    return _nativeFinvuManager
        .getEntityInfo(entityId, entityType)
        .then(
          (entityInfo) => FinvuEntityInfo(
            entityId: entityInfo.entityId,
            entityName: entityInfo.entityName,
            entityIconUri: entityInfo.entityIconUri,
            entityLogoUri: entityInfo.entityLogoUri,
            entityLogoWithNameUri: entityInfo.entityLogoWithNameUri,
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuAccountLinkingRequestReference> linkAccounts(
    FinvuFIPDetails fipDetails,
    List<FinvuDiscoveredAccountInfo> accounts,
  ) {
    final nativeFipDetails = NativeFIPDetails(
      fipId: fipDetails.fipId,
      typeIdentifiers: fipDetails.typeIdentifiers
          .map(
            (typeIdentifier) => NativeFIPFiTypeIdentifier(
              fiType: typeIdentifier.fiType,
              identifiers: typeIdentifier.identifiers
                  .map(
                    (identifier) => NativeTypeIdentifier(
                      type: identifier.type,
                      category: identifier.category,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );

    final nativeAccounts = accounts
        .map(
          (account) => NativeDiscoveredAccountInfo(
            accountType: account.accountType,
            accountReferenceNumber: account.accountReferenceNumber,
            maskedAccountNumber: account.maskedAccountNumber,
            fiType: account.fiType,
          ),
        )
        .toList();

    return _nativeFinvuManager
        .linkAccounts(nativeFipDetails, nativeAccounts)
        .then(
          (value) => FinvuAccountLinkingRequestReference(
              referenceNumber: value.referenceNumber),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuConfirmAccountLinkingInfo> confirmAccountLinking(
    FinvuAccountLinkingRequestReference requestReference,
    String otp,
  ) {
    final nativeRequestReference = NativeAccountLinkingRequestReference(
      referenceNumber: requestReference.referenceNumber,
    );
    return _nativeFinvuManager
        .confirmAccountLinking(nativeRequestReference, otp)
        .then(
          (value) => FinvuConfirmAccountLinkingInfo(
            linkedAccounts: value.linkedAccounts.nonNulls
                .map(
                  (account) => FinvuLinkedAccountInfo(
                    customerAddress: account.customerAddress,
                    linkReferenceNumber: account.linkReferenceNumber,
                    accountReferenceNumber: account.accountReferenceNumber,
                    status: account.status,
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

  Future<List<FinvuLinkedAccountDetailsInfo>> fetchLinkedAccounts() {
    return _nativeFinvuManager
        .fetchLinkedAccounts()
        .then(
          (value) => value.linkedAccounts.nonNulls
              .map(
                (account) => FinvuLinkedAccountDetailsInfo(
                  userId: account.userId,
                  fipId: account.fipId,
                  fipName: account.fipName,
                  maskedAccountNumber: account.maskedAccountNumber,
                  accountReferenceNumber: account.accountReferenceNumber,
                  linkReferenceNumber: account.linkReferenceNumber,
                  consentIdList: account.consentIdList?.nonNulls.toList(),
                  fiType: account.fiType,
                  accountType: account.accountType,
                  linkedAccountUpdateTimestamp: account
                              .linkedAccountUpdateTimestamp !=
                          null
                      ? DateTime.tryParse(account.linkedAccountUpdateTimestamp!)
                      : null,
                  authenticatorType: account.authenticatorType,
                ),
              )
              .toList(),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> initiateMobileVerification(String mobileNumber) {
    return _nativeFinvuManager
        .initiateMobileVerification(mobileNumber)
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> completeMobileVerification(String mobileNumber, String otp) {
    return _nativeFinvuManager
        .completeMobileVerification(mobileNumber, otp)
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuProcessConsentRequestResponse> approveConsentRequest(
    FinvuConsentRequestDetailInfo consentInfo,
    List<FinvuLinkedAccountDetailsInfo> linkedAccounts,
  ) {
    final nativeConsentInfo = NativeConsentRequestDetailInfo(
      consentHandleId: consentInfo.consentHandle,
      financialInformationUser: NativeFinancialInformationEntity(
        id: consentInfo.financialInformationUser.id,
        name: consentInfo.financialInformationUser.name,
      ),
      statusLastUpdateTimestamp:
          consentInfo.statusLastUpdateTimestamp?.toIso8601String() ?? "",
      consentPurposeInfo: NativeConsentPurposeInfo(
        code: consentInfo.consentPurposeInfo.code,
        text: consentInfo.consentPurposeInfo.text,
      ),
      consentDisplayDescriptions: consentInfo.consentDisplayDescriptions,
      dataDateTimeRange: NativeDateTimeRange(
        from: consentInfo.dataDateTimeRange.from?.toIso8601String() ?? "",
        to: consentInfo.dataDateTimeRange.to?.toIso8601String() ?? "",
      ),
      consentDateTimeRange: NativeDateTimeRange(
        from: consentInfo.consentDateTimeRange.from?.toIso8601String() ?? "",
        to: consentInfo.consentDateTimeRange.to?.toIso8601String() ?? "",
      ),
      consentDataFrequency: NativeConsentDataFrequency(
        unit: consentInfo.consentDataFrequency.unit,
        value: consentInfo.consentDataFrequency.value,
      ),
      consentDataLifePeriod: NativeConsentDataLifePeriod(
        unit: consentInfo.consentDataLifePeriod.unit,
        value: consentInfo.consentDataLifePeriod.value,
      ),
    );

    final nativeLinkedAccounts = linkedAccounts
        .map(
          (account) => NativeLinkedAccountDetailsInfo(
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
          ),
        )
        .toList();

    return _nativeFinvuManager
        .approveConsentRequest(nativeConsentInfo, nativeLinkedAccounts)
        .then(
          (response) => FinvuProcessConsentRequestResponse(
            consentIntentId: response.consentIntentId,
            consentInfo: response.consentInfo?.nonNulls
                .map(
                  (consentInfo) => FinvuConsentInfo(
                    consentId: consentInfo.consentId,
                    fipId: consentInfo.fipId,
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

  Future<FinvuProcessConsentRequestResponse> denyConsentRequest(
    FinvuConsentRequestDetailInfo consentInfo,
  ) {
    final nativeConsentInfo = NativeConsentRequestDetailInfo(
      consentHandleId: consentInfo.consentHandle,
      statusLastUpdateTimestamp:
          consentInfo.statusLastUpdateTimestamp?.toIso8601String() ?? "",
      financialInformationUser: NativeFinancialInformationEntity(
        id: consentInfo.financialInformationUser.id,
        name: consentInfo.financialInformationUser.name,
      ),
      consentPurposeInfo: NativeConsentPurposeInfo(
        code: consentInfo.consentPurposeInfo.code,
        text: consentInfo.consentPurposeInfo.text,
      ),
      consentDisplayDescriptions: consentInfo.consentDisplayDescriptions,
      dataDateTimeRange: NativeDateTimeRange(
        from: consentInfo.dataDateTimeRange.from?.toIso8601String() ?? "",
        to: consentInfo.dataDateTimeRange.to?.toIso8601String() ?? "",
      ),
      consentDateTimeRange: NativeDateTimeRange(
        from: consentInfo.consentDateTimeRange.from?.toIso8601String() ?? "",
        to: consentInfo.consentDateTimeRange.to?.toIso8601String() ?? "",
      ),
      consentDataFrequency: NativeConsentDataFrequency(
        unit: consentInfo.consentDataFrequency.unit,
        value: consentInfo.consentDataFrequency.value,
      ),
      consentDataLifePeriod: NativeConsentDataLifePeriod(
        unit: consentInfo.consentDataLifePeriod.unit,
        value: consentInfo.consentDataLifePeriod.value,
      ),
    );

    return _nativeFinvuManager
        .denyConsentRequest(nativeConsentInfo)
        .then(
          (response) => FinvuProcessConsentRequestResponse(
            consentIntentId: response.consentIntentId,
            consentInfo: response.consentInfo?.nonNulls
                .map(
                  (consentInfo) => FinvuConsentInfo(
                    consentId: consentInfo.consentId,
                    fipId: consentInfo.fipId,
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

  Future<void> revokeConsent(String consentId, FinvuUserConsentInfo consent,
      AccountAggregator? accountAggregator, FIPReference? fipDetails) {
    final nativeConsent = NativeUserConsentInfoDetails(
      consentId: consentId,
      consentIntentEntityId: consent.consentIntentEntityId,
      consentIdList: consent.consentIdList,
      consentIntentEntityName: consent.consentIntentEntityName,
      consentIntentUpdateTimestamp:
          consent.consentIntentUpdateTimestamp?.toIso8601String() ?? "",
      consentPurposeText: consent.consentPurposeText,
      status: consent.status,
    );
    final nativeAA = accountAggregator != null
        ? NativeAccountAggregator(id: accountAggregator.id!)
        : null;
    final nativeFipDetails = fipDetails != null
        ? NativeFIPReference(
            fipId: fipDetails.fipId, fipName: fipDetails.fipName)
        : null;

    return _nativeFinvuManager
        .revokeConsent(nativeConsent, nativeAA, nativeFipDetails)
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuConsentHandleStatusResponse> getConsentHandleStatus(
    String handleId,
  ) {
    return _nativeFinvuManager
        .getConsentHandleStatus(handleId)
        .then(
          (response) => FinvuConsentHandleStatusResponse(
            status: response.status,
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<void> logout() {
    return _nativeFinvuManager.logout().catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }

  Future<FinvuConsentRequestDetailInfo> getConsentRequestDetails(
    String handleId,
  ) {
    return _nativeFinvuManager
        .getConsentRequestDetails(handleId)
        .then(
          (response) => FinvuConsentRequestDetailInfo(
            consentId: response.consentId,
            consentHandle: response.consentHandleId,
            statusLastUpdateTimestamp:
                response.statusLastUpdateTimestamp != null
                    ? DateTime.parse(response.statusLastUpdateTimestamp!)
                    : null,
            financialInformationUser: FinvuFinancialInformationEntityInfo(
              id: response.financialInformationUser.id,
              name: response.financialInformationUser.name,
            ),
            consentPurposeInfo: FinvuConsentPurposeInfo(
              code: response.consentPurposeInfo.code,
              text: response.consentPurposeInfo.text,
            ),
            consentDisplayDescriptions:
                response.consentDisplayDescriptions.nonNulls.toList(),
            dataDateTimeRange: FinvuDateTimeRange(
              from: DateTime.tryParse(response.dataDateTimeRange.from),
              to: DateTime.tryParse(response.dataDateTimeRange.to),
            ),
            consentDateTimeRange: FinvuDateTimeRange(
              from: DateTime.tryParse(response.consentDateTimeRange.from),
              to: DateTime.tryParse(response.consentDateTimeRange.to),
            ),
            consentDataFrequency: FinvuConsentDataFrequency(
              unit: response.consentDataFrequency.unit,
              value: response.consentDataFrequency.value,
            ),
            consentDataLifePeriod: FinvuConsentDataLifePeriod(
              unit: response.consentDataLifePeriod.unit,
              value: response.consentDataLifePeriod.value,
            ),
            fiTypes: response.fiTypes?.nonNulls.toList(),
          ),
        )
        .catchError(
          (e) => throw FinvuException.from(e),
          test: _platformExceptionTest,
        );
  }
}
