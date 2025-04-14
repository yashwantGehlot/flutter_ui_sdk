enum Environment { dev, prod }

class FinvuAppConfig {
  static Environment? environment;
  static late Map<String, dynamic> _config;

  static bool isDevelopment() => environment == Environment.dev;
  static bool isProduction() => environment == Environment.prod;

  static Future<void> initialize(Environment env) async {
    environment = env;
    _config = _getConfigFor(env);
  }

  static Map<String, dynamic> _getConfigFor(Environment env) {
    switch (env) {
      case Environment.dev:
        return _devConfig;
      case Environment.prod:
        return _prodConfig;
    }
  }

  static String get apiUrl => _config["apiUrl"];

  static List<String>? get certificatePins {
    var pins = _config["certificatePins"] as List<dynamic>?;
    return pins?.map((pin) => pin as String).toList();
  }

  static const Map<String, dynamic> _devConfig = {
    "apiUrl": "wss://webvwdev.finvu.in/api",
    "certificatePins": [
      "R6wXZnQsKKyg56qFKQNytvygyr/o4Mkq1VXL5LenBYI=",
      "bdrBhpj38ffhxpubzkINl0rG+UyossdhcBYj+Zx2fcc="
    ],
  };

  static const Map<String, dynamic> _prodConfig = {
    "apiUrl": "wss://wsslive.finvu.in/api",
    "certificatePins": [
      "sbwmzb+GDVnfeIXamhbaeFHbFzEi83xGT3EKHt5QGbU=",
      "NYbU7PBwV4y9J67c4guWTki8FJ+uudrXL0a4V4aRcrg=",
      "6ItJWWXcuop8ZWO0C/FslqC0mbIhpnCPCerdYkJkD9o=",
      "OdSlmQD9NWJh4EbcOHBxkhygPwNSwA9Q91eounfbcoE="
    ],
  };
}
