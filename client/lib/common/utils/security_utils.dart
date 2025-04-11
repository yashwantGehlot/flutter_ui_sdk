import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:screen_protector/screen_protector.dart';

class SecurityUtils {
  static const MethodChannel _channel =
      MethodChannel('com.finvu.channel/security');

  static Future<bool> isSecureLockEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('isSecureLockEnabled');
      return result;
    } on PlatformException catch (e) {
      debugPrint("Error occurred during secure lock detection: $e");
      return false;
    }
  }

  static Future<bool> isDeviceSecurityCompromised() async {
    bool jailbroken = false;
    bool developerMode = false;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } catch (e) {
      debugPrint("Error occurred during jailbreak detection: $e");
    }
    return jailbroken && !developerMode;
  }

  static Future<void> enableScreenProtection() async {
    await ScreenProtector.protectDataLeakageWithColor(Colors.black);
  }

  static Future<void> disableScreenProtection() async {
    await ScreenProtector.protectDataLeakageWithColorOff();
  }
}
