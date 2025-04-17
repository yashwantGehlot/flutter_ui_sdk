import 'package:flutter/material.dart';

class FinvuUIConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color currentColor;
  final TextTheme textTheme;
  final String fontFamily;
  final Widget? loderWidget;
  final bool isElevatedButton;
  final ElevatedButtonThemeData? elevatedButtonTheme;
  final OutlinedButtonThemeData? outlinedButtonTheme;

  FinvuUIConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.currentColor,
    required this.textTheme,
    required this.fontFamily,
    required this.loderWidget,
    this.isElevatedButton = true,
    this.elevatedButtonTheme,
    this.outlinedButtonTheme,
  });
}

class FIUDetails {
  final String fiuId;
  final String fiuName;

  FIUDetails({
    required this.fiuId,
    required this.fiuName,
  });
}

class SDKConfig {
  final String logoUrl;
  final bool isPartOfAsset;

  SDKConfig({
    required this.logoUrl,
    required this.isPartOfAsset,
  });
}

class LoginConfig {
  final String mobileNumber;
  final String consentHandle;

  LoginConfig({
    required this.mobileNumber,
    required this.consentHandle,
  });
}
