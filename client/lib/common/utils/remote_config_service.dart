class RemoteConfigService {
  final Map<String, dynamic> _data;

  RemoteConfigService() : _data = _defaultData;

  RemoteConfigService._withData(this._data);

  static final Map<String, dynamic> _defaultData = {
    'minimumSupportedVersion': "2.1.0",
    'androidStoreLink':
        "https://play.google.com/store/apps/details?id=com.finvu",
    "iosStoreLink": "https://apps.apple.com/us/app/finvu/id6499302887",
    "accountLinkingOtpMaxLength": 10,
  };

  int getInt(String key) => _data[key] as int;
  String getString(String key) => _data[key] as String;
  bool getBool(String key) => _data[key] as bool;

  String get minimumSupportedVersion => getString('minimumSupportedVersion');

  String get androidStoreLink => getString('androidStoreLink');

  String get iosStoreLink => getString('iosStoreLink');

  int get accountLinkingOtpMaxLength => getInt('accountLinkingOtpMaxLength');
}
