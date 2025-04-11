import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigService {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigService._privateConstructor();

  static final RemoteConfigService _instance =
      RemoteConfigService._privateConstructor();

  factory RemoteConfigService() {
    return _instance;
  }

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults(defaults);

    // Do not wait for fetch and activate for 2 reasons:
    // 1. Slower app start time
    // 2. In case of no network, fetch and activate will throw an exception
    //    and white screen will be shown to the user
    try {
      _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint("failed to fetchAndActive remote config exception=$e");
    }
  }

  static const defaults = <String, dynamic>{
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

  int get testSettings => _remoteConfig.getInt('testConfigKey');

  String get minimumSupportedVersion =>
      _remoteConfig.getString('minimumSupportedVersion');

  String get androidStoreLink => _remoteConfig.getString('androidStoreLink');

  String get iosStoreLink => _remoteConfig.getString('iosStoreLink');

  int get accountDataFetchPollIntervalInSeconds =>
      _remoteConfig.getInt('accountDataFetchPollIntervalInSeconds');

  int get accountDataFetchPollTimeoutInSeconds =>
      _remoteConfig.getInt('accountDataFetchPollTimeoutInSeconds');

  bool get isAccountDataFeatureEnabled =>
      _remoteConfig.getBool('isAccountDataFeatureEnabled');

  int get selfConsentExpireTimeInDays =>
      _remoteConfig.getInt('selfConsentExpireTimeInDays');

  String get selfConsentMode => _remoteConfig.getString('selfConsentMode');

  String get selfConsentFetchType =>
      _remoteConfig.getString('selfConsentFetchType');

  String get selfConsentFrequencyUnit =>
      _remoteConfig.getString('selfConsentFrequencyUnit');

  int get selfConsentFrequencyValue =>
      _remoteConfig.getInt('selfConsentFrequencyValue');

  String get selfConsentDataLifeUnit =>
      _remoteConfig.getString('selfConsentDataLifeUnit');

  int get selfConsentDataLifeValue =>
      _remoteConfig.getInt('selfConsentDataLifeValue');

  bool get deviceBindingEnabled =>
      _remoteConfig.getBool('deviceBindingEnabled');

  bool get deviceBindingAPIEnabled =>
      _remoteConfig.getBool('deviceBindingAPIEnabled');

  int get totpGenerationInterval =>
      _remoteConfig.getInt('totpGenerationInterval');

  int get deviceBindingOtpTimerInterval =>
      _remoteConfig.getInt('deviceBindingOtpTimerInterval');

  int get accountLinkingOtpMaxLength =>
      _remoteConfig.getInt('accountLinkingOtpMaxLength');

  String get selfConsentPurposeType =>
      _remoteConfig.getString('selfConsentPurposeType');
}
