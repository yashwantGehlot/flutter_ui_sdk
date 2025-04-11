import 'dart:io';

import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:finvu_flutter_sdk/common/utils/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateUtils {
  static Future<bool> shouldForceUpdateApp() async {
    final remoteConfig = RemoteConfigService();
    var minimumRequiredVersionString = remoteConfig.minimumSupportedVersion;
    if (minimumRequiredVersionString.isEmpty) {
      return false;
    }

    int minimumRequiredVersion = versionToInt(minimumRequiredVersionString);

    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    int currentVersion = versionToInt(version);

    return currentVersion < minimumRequiredVersion;
  }

  static Future<void> goToStore() async {
    final remoteConfig = RemoteConfigService();
    if (Platform.isAndroid) {
      launch(Uri.parse(remoteConfig.androidStoreLink));
    } else if (Platform.isIOS) {
      launch(Uri.parse(remoteConfig.iosStoreLink));
    }
  }

  static int versionToInt(String version) => version
      .split('-')
      .first
      .split('.')
      .map(int.parse)
      .reduce((value, element) => value * 100 + element);
}
