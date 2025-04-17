import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_info.dart';

class SelfConsentDetails {
  SelfConsentDetails({
    required this.createTime,
    required this.startTime,
    required this.expireTime,
    required this.linkedAccounts,
    required this.fiTypes,
    required this.consentTypes,
    required this.mode,
    required this.fetchType,
    required this.frequency,
    required this.dataLife,
    required this.purposeText,
    required this.purposeType,
  });

  List<String> fiTypes;
  List<String> consentTypes;
  DateTime createTime;
  DateTime startTime;
  DateTime expireTime;
  List<LinkedAccountInfo> linkedAccounts;
  String mode;
  String fetchType;
  FinvuConsentDataFrequency frequency;
  FinvuConsentDataLifePeriod dataLife;
  String purposeText;
  String purposeType;
}
