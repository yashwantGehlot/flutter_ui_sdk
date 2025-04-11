import 'dart:convert';

import 'package:flutter/services.dart';

enum Environment { dev, prod }

class FinvuAppConfig {
  static Environment? environment;

  static isDevelopment() => environment == Environment.dev;

  static isProduction() => environment == Environment.prod;

  static late Map<String, dynamic> _config;

  static Future<void> initialize(Environment env) async {
    environment = env;
    final configString =
        await rootBundle.loadString("lib/assets/config/$environment.json");
    _config = jsonDecode(configString);
  }

  static String get apiUrl {
    return _config["apiUrl"];
  }

  static List<String>? get certificatePins {
    var pins = _config["certificatePins"] as List<dynamic>?;
    return pins?.map((pin) => pin as String).nonNulls.toList();
  }

  static String get androidSha256 {
    return _config["android"]["sha256"];
  }

  static String get iosTeamId {
    return _config["ios"]["teamId"];
  }

  static String get getPackageName {
    return _config["packageName"];
  }
}
