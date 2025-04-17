import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_info.dart';

enum ConsentType {
  transactions("TRANSACTIONS"),
  profile("PROFILE"),
  summary("SUMMARY");

  final String value;

  const ConsentType(this.value);
}

class ConsentDetails extends FinvuConsentInfoDetails {
  FinvuConsentRequestDetailInfo? consentRequestDetailInfo;
  FinvuConsentInfoDetails? consentInfoDetails;
  FinvuEntityInfo entityInfo;

  ConsentDetails.fromConsentRequestDetailInfo(
    FinvuConsentRequestDetailInfo this.consentRequestDetailInfo,
    this.entityInfo,
  ) : super(
            consentId: consentRequestDetailInfo.consentId,
            consentHandle: consentRequestDetailInfo.consentHandle,
            statusLastUpdateTimestamp:
                consentRequestDetailInfo.statusLastUpdateTimestamp,
            consentStatus: Constants.pending,
            consentDateTimeRange: consentRequestDetailInfo.consentDateTimeRange,
            consentDataFrequency: consentRequestDetailInfo.consentDataFrequency,
            consentDataLifePeriod:
                consentRequestDetailInfo.consentDataLifePeriod,
            consentDisplayDescriptions:
                consentRequestDetailInfo.consentDisplayDescriptions,
            financialInformationProvider: null,
            financialInformationUser:
                consentRequestDetailInfo.financialInformationUser,
            consentPurposeInfo: consentRequestDetailInfo.consentPurposeInfo,
            dataDateTimeRange: consentRequestDetailInfo.dataDateTimeRange,
            accounts: [],
            fiTypes: consentRequestDetailInfo.fiTypes,
            accountAggregator: null);

  ConsentDetails.fromConsentInfoDetail(
    FinvuConsentInfoDetails this.consentInfoDetails,
    this.entityInfo,
    FinvuUserConsentInfo? consent,
  ) : super(
            consentId: consentInfoDetails.consentId,
            consentHandle: consentInfoDetails.consentHandle,
            statusLastUpdateTimestamp:
                consentInfoDetails.statusLastUpdateTimestamp,
            consentStatus: consentInfoDetails.consentStatus,
            consentDateTimeRange: consentInfoDetails.consentDateTimeRange,
            consentDataFrequency: consentInfoDetails.consentDataFrequency,
            consentDataLifePeriod: consentInfoDetails.consentDataLifePeriod,
            consentDisplayDescriptions:
                consentInfoDetails.consentDisplayDescriptions,
            financialInformationProvider:
                consentInfoDetails.financialInformationProvider,
            financialInformationUser:
                consentInfoDetails.financialInformationUser,
            consentPurposeInfo: consentInfoDetails.consentPurposeInfo,
            dataDateTimeRange: consentInfoDetails.dataDateTimeRange,
            accounts: consentInfoDetails.accounts,
            finvuUserConsentInfo: consent,
            fiTypes: consentInfoDetails.fiTypes,
            accountAggregator: consentInfoDetails.accountAggregator);
}
