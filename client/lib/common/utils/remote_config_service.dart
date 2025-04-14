import 'package:flutter/material.dart';

class RemoteConfigService {
  final Map<String, dynamic> _data;

  RemoteConfigService() : _data = _defaultData;

  RemoteConfigService._withData(this._data);

  static final Map<String, dynamic> _defaultData = {
    'testConfigKey': 0,
    'minimumSupportedVersion': "2.1.0",
    'androidStoreLink':
        "https://play.google.com/store/apps/details?id=com.finvu",
    "iosStoreLink": "https://apps.apple.com/us/app/finvu/id6499302887",
    "accountDataFetchPollIntervalInSeconds": 3,
    "accountDataFetchPollTimeoutInSeconds": 120,
    "isAccountDataFeatureEnabled": false,
    "selfConsentExpireTimeInDays": 7,
    "selfConsentMode": "VIEW",
    "selfConsentFetchType": "PERIODIC",
    "selfConsentFrequencyUnit": "MONTH",
    "selfConsentFrequencyValue": 4,
    "selfConsentDataLifeUnit": "DAY",
    "selfConsentDataLifeValue": 7,
    "deviceBindingEnabled": false,
    "deviceBindingAPIEnabled": false,
    "totpGenerationInterval": 180,
    "deviceBindingOtpTimerInterval": 60,
    "accountLinkingOtpMaxLength": 10,
    "selfConsentPurposeType": "ONE_TIME_CONSENT"
  };

  int getInt(String key) => _data[key] as int;
  String getString(String key) => _data[key] as String;
  bool getBool(String key) => _data[key] as bool;

  int get testSettings => getInt('testConfigKey');

  String get minimumSupportedVersion => getString('minimumSupportedVersion');

  String get androidStoreLink => getString('androidStoreLink');

  String get iosStoreLink => getString('iosStoreLink');

  int get accountDataFetchPollIntervalInSeconds =>
      getInt('accountDataFetchPollIntervalInSeconds');

  int get accountDataFetchPollTimeoutInSeconds =>
      getInt('accountDataFetchPollTimeoutInSeconds');

  bool get isAccountDataFeatureEnabled =>
      getBool('isAccountDataFeatureEnabled');

  int get selfConsentExpireTimeInDays => getInt('selfConsentExpireTimeInDays');

  String get selfConsentMode => getString('selfConsentMode');

  String get selfConsentFetchType => getString('selfConsentFetchType');

  String get selfConsentFrequencyUnit => getString('selfConsentFrequencyUnit');

  int get selfConsentFrequencyValue => getInt('selfConsentFrequencyValue');

  String get selfConsentDataLifeUnit => getString('selfConsentDataLifeUnit');

  int get selfConsentDataLifeValue => getInt('selfConsentDataLifeValue');

  bool get deviceBindingEnabled => getBool('deviceBindingEnabled');

  bool get deviceBindingAPIEnabled => getBool('deviceBindingAPIEnabled');

  int get totpGenerationInterval => getInt('totpGenerationInterval');

  int get deviceBindingOtpTimerInterval =>
      getInt('deviceBindingOtpTimerInterval');

  int get accountLinkingOtpMaxLength => getInt('accountLinkingOtpMaxLength');

  String get selfConsentPurposeType => getString('selfConsentPurposeType');
}
